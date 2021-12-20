#' Perform statistical tests w/'hacksaw-like' syntax
#'
#' @param data a table of data
#' @param ... possibly named formulas to pass on to tests
#' @param args a list of arguments to pass on to tests. Cf. ?t.test, ?chisq.test
#' @param tidier which tidier to use from the broom package
#'
#' @return a list
#' @rdname test-splits
#' @importFrom utils modifyList
#' @export
#'
#' @examples
#' library(infer)
#' gss %>%
#'     t_test_split(
#'         hours ~ college,
#'         hours ~ sex
#'         )
#'
#' gss %>%
#'     t_test_split(
#'         t1 = hours ~ college,
#'         t2 = hours ~ sex,
#'         args = list(alternative = "greater", conf.level = 0.9)
#'         )
t_test_split <- function(data,
                         ...,
                         args
                         ) {
  stopifnot("data must be a data frame" = is.data.frame(data))
  def_args <- list(alternative = c("two.sided", "less", "greater"),
                   mu = 0,
                   paired = FALSE,
                   var.equal = FALSE,
                   conf.level = 0.95)
  if (!missing(args)) def_args <- modifyList(def_args, args)
  dots <- rlang::dots_list(..., .named = TRUE)
  out <- purrr::map(dots, ~(do.call(t.test, c(list(formula = .x, data = data), def_args))))
  purrr::map(out, broom::glance)
}

#' @rdname test-splits
#' @export
chisq_split <- function(data,
                        ...,
                        args,
                        tidier = c("tidy", "glance", "augment")
                        ) {
  stopifnot("data must be a data frame" = is.data.frame(data))
  dots <- rlang::dots_list(..., .named = TRUE)
  test_vars <- purrr::map(dots, all.vars)
  test_tables <- purrr::map(test_vars, ~table(data[,.x]))
  missing_args <- missing(args)
  tf <- utils::getFromNamespace(paste0(match.arg(tidier), ".htest"), "broom")
  out <- purrr::map(test_tables, ~{
    def_args <- list(correct = TRUE,
                     p = rep(1/length(.x), length(.x)),
                     rescale.p = FALSE,
                     simulate.p.value = FALSE,
                     B = 2000)
    if (!missing_args) def_args <- modifyList(def_args, args)
    do.call(chisq.test, c(list(x = .x), def_args))
  })
  purrr::map(out, tf)
}

#' @rdname test-splits
#' @export
lm_split <- function(data,
                     ...,
                     args,
                     tidier = c("tidy", "glance", "augment")
                     ) {

  stopifnot("data must be a data frame" = is.data.frame(data))
  tf <- utils::getFromNamespace(paste0(match.arg(tidier), ".lm"), "broom")
  dots <- rlang::dots_list(..., .named = TRUE)
  purrr::map(dots, ~tf(lm(.x, data = data)))
}

#' Recycle dots pipe
#'
#' Pipe a recyclable object into a function with dots. Functionally identical to magrittr pipe.
#'
#' @name recycle-pipe
#' @importFrom magrittr %>%
#' @aliases %>%
#' @usage lhs \%>\% rhs
#' @param lhs A value or the magrittr placeholder.
#' @param rhs A function call using the magrittr semantics.
#' @export
`%@%` <- magrittr::`%>%`


