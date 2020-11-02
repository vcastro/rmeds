data("rxnorm_in")
data("rxnorm_in_map")

test_that("rxnorm_in has no NA", {
  expect_equal(
    colnames(rxnorm_in)[ apply(rxnorm_in, 2, anyNA) ],
    character(0)
  )
})

test_that("all rxnorm_in_map IN_RXCUI exist in rxnorm_in", {
  expect_equal(
    nrow(rxnorm_in_map[!rxnorm_in_map$IN_RXCUI %in% rxnorm_in$IN_RXCUI,]),
    0
  )
})
