#' Drug ingredients in RXNORM
#'
#' A dataset containing RXNORM drug ingredients (IN) and
#' combination drugs as multi-ingredients (MIN) available in the
#' RXNORM current prescribable content requiring no licenses for use.  The
#' subset excludes suppressed and obsolete drugs, drugs only prescribed
#' outside the US, and drugs only for veterinary use.
#'
#' @format A data frame with 6443 rows and 3 variables:
#' \describe{
#'   \item{IN_RXCUI}{RXCUI for the drug ingredient or multi-ingredient (MIN)}
#'   \item{IN_TTY}{Type of ingredient (IN, MIN)}
#'   \item{IN_STR}{Name of drug ingredient}
#' }
#'
#' @seealso \link{rxnorm_in_map}
#' @seealso
#' \url{https://www.nlm.nih.gov/research/umls/rxnorm/docs/rxnormfiles.html}
"rxnorm_in"


#' Mapping of drug ingredients to component drugs and other identifiers
#'
#' A dataset containing mappings of component drugs and codes to RXNORM drug
#' ingredients (IN) extracted from the RXNORM relationships (RXNREL) and
#' attributes (RXNSAT) tables.
#' Mappings are available for RXNORM component types (SCD, SBD, SCDC, SCDF,
#' SCDG, DP), to National Drug Codes (NDC) and Healthcare Common Procedure
#' Coding System J codes (HCPCS).  These mappings do not have license
#' restrictions.
#'
#' @format A data frame with 555023 rows and 6 variables:
#' \describe{
#'   \item{IN_RXCUI}{RXCUI for the drug ingredient or multi-ingredient (MIN)}
#'   \item{IN_TTY}{Type of ingredient (IN, MIN)}
#'   \item{IN_STR}{Name of drug ingredient}
#'   \item{drug_code}{Drug code}
#'   \item{drug_name}{Name of component drug in RXNORM.  NA for NDC and HCPCS}
#'   \item{drug_type}{Type of drug component/code, including: \itemize{
#'         \item{SCD: Semantic clinical drug = Ingredient + Strength + Dose
#'         form}
#'         \item{SBD: Semantic branded drug =  Ingredient + Strength + Dose
#'         form+Brand name}
#'         \item{SCDC: Semantic Clinical Drug Component = Ingredient + Strength}
#'         \item{SCDF: Semantic Clinical Drug Form = Ingredient + Dose form}
#'         \item{SCDG: Semantic Clinical Drug Group = Ingredient + Dose form
#'         group}
#'         \item{DP: Drug Pack = Ingredient + Strength}
#'         \item{NDC: National Drug Codes, packaging code.  Includes both RXNORM
#'         normalized code (without dashes) and non-normalized codes}
#'         \item{HCPCS: Healthcare Common Procedure Coding System J codes}
#'         }
#'   }
#' }
"rxnorm_in_map"
