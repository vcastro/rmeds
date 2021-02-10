
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rmeds

<!-- badges: start -->

[![R build
status](https://github.com/vcastro/rmeds/workflows/R-CMD-check/badge.svg)](https://github.com/vcastro/rmeds/actions)
<!-- badges: end -->

The goal of rmeds is to map medications from electronic health record
(EHR) and claims datasets to RXNORM ingredients and also to various drug
classes

## Installation

You can install the development version of rmeds from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("vcastro/rmeds")
```

## Example

This is a basic example to load the full list of RXNORM ingredients:

``` r
library(rmeds)

## load list of ingredients
data("rxnorm_in")
```
