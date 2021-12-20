
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hacksawstats

<!-- badges: start -->

<!-- badges: end -->

The goal of hacksawstats is to do simple stats quicker.

## Installation

You can install the development version of hacksawstats from GitHub
with:

``` r
remotes::install_github("daranzolin/hacksawstats")
```

## Example

The `%@%` operator is identical to `%>%` and is used only to alert the
user to different behavior within the `*_split` functions (the piped
object is recycled).

``` r
library(hacksawstats)
library(infer)

gss %@% 
  t_test_split(
    hours ~ college,
    hours ~ sex
  )
#> $`hours ~ college`
#> # A tibble: 1 x 10
#>   estimate estimate1 estimate2 statistic p.value parameter conf.low conf.high
#>      <dbl>     <dbl>     <dbl>     <dbl>   <dbl>     <dbl>    <dbl>     <dbl>
#> 1    -1.54      40.8      42.4     -1.12   0.264      366.    -4.24      1.16
#> # … with 2 more variables: method <chr>, alternative <chr>
#> 
#> $`hours ~ sex`
#> # A tibble: 1 x 10
#>   estimate estimate1 estimate2 statistic p.value parameter conf.low conf.high
#>      <dbl>     <dbl>     <dbl>     <dbl>   <dbl>     <dbl>    <dbl>     <dbl>
#> 1     6.65      44.5      37.9      5.13 4.25e-7      490.     4.10      9.19
#> # … with 2 more variables: method <chr>, alternative <chr>

mtcars %@% 
  lm_split(
    model1 = mpg ~ wt,
    model2 = mpg ~ wt + hp
  )
#> $model1
#> # A tibble: 2 x 5
#>   term        estimate std.error statistic  p.value
#>   <chr>          <dbl>     <dbl>     <dbl>    <dbl>
#> 1 (Intercept)    37.3      1.88      19.9  8.24e-19
#> 2 wt             -5.34     0.559     -9.56 1.29e-10
#> 
#> $model2
#> # A tibble: 3 x 5
#>   term        estimate std.error statistic  p.value
#>   <chr>          <dbl>     <dbl>     <dbl>    <dbl>
#> 1 (Intercept)  37.2      1.60        23.3  2.57e-20
#> 2 wt           -3.88     0.633       -6.13 1.12e- 6
#> 3 hp           -0.0318   0.00903     -3.52 1.45e- 3
```
