#' Mapping of drug ingredients to MeSH indications
#'
#' A dataset containing mappings of RXNORM drug ingredients to Medical Subject
#' Headings (MeSH) indications extracted from RxMix.
#'
#' @format A data frame with 7950 rows and 5 variables:
#' \describe{
#'   \item{IN_RXCUI}{RXCUI for the drug ingredient or multi-ingredient (MIN)}
#'   \item{IN_STR}{Name of drug ingredient}
#'   \item{RELA}{Type of indication, either may_treat, may_prevent or
#'   may_diagnose}
#'   \item{MESH_ID}{MeSH disease identifier}
#'   \item{MESH_STR}{MeSH disease name}
#' }
#'
"rxnorm_mesh_indications"
