options(tidyverse.quiet = TRUE)
library(tidyverse)
source('data-raw/utils.R')

rxnorm_url =
  "https://download.nlm.nih.gov/rxnorm/RxNorm_full_prescribe_10052020.zip"

mesh_ind_fn =
  "data-raw/10f0fdb028af74a4abd61ce9459417ec.text"

##########################################################
###
### RXNORM Current Prescribable Subset
###
##########################################################

download_extract(url = rxnorm_url,
                 exdir = "data-raw",
                 files = c("rrf/RXNCONSO.RRF",
                           "rrf/RXNREL.RRF",
                           "rrf/RXNSAT.RRF"))


rxnorm_src <- read_delim("data-raw/RXNCONSO.RRF", delim="|",
                         col_types = cols(.default = col_character()),
                         col_names = c("RXCUI", "LAT", "TS", "LUI", "STT",
                                       "SUI", "ISPREF", "RXAUI", "SAUI", "SCUI",
                                       "SDUI", "SAB", "TTY", "CODE", "STR",
                                       "SRL", "SUPPRESS", "CVF", "ignore")) %>%
              select(-ignore)


rxnorm_rel <- read_delim("data-raw/RXNREL.RRF", delim="|",
                         col_types = cols(.default = col_character()),
                         col_names = c("RXCUI1", "RXAUI1", "STYPE1",
                                       "REL", "RXCUI2", "RXAUI2", "STEP2",
                                       "RELA", "RUI", "SRUI", "SAB", "SL",
                                       "DIR", "RG", "SUPPRESS", "CVF",
                                       "ignore"))

rxnorm_attr <- read_delim("data-raw/RXNSAT.RRF", delim="|",
                          col_types = cols(.default = col_character()),
                          col_names = FALSE) %>%
  select(RXCUI = X1,
         SAB = X10,
         ATN = X9,
         ATV = X11)

rxnorm_mesh_indications <- read_delim(mesh_ind_fn,
                                      delim="|",
                          col_types = cols(.default = col_character()),
                          col_names = paste0("X", 1:24)) %>%
  filter(X8 %in% c("IN", "MIN")) %>%
  select(IN_RXCUI = X12, IN_STR = X10, RELA = X14, MESH_ID = X16 , MESH_STR = X18 ) %>%
  unique()

rxnorm_hcpcs <- read_csv("data-raw/rxnorm_hcpcs_map.csv",
                         col_types = cols(.default = col_character()))


##MIN: add parent column to in list

rxnorm_in <- rxnorm_src %>%
  filter(TTY %in% c("IN", "MIN")) %>%
  select(IN_RXCUI = RXCUI, IN_TTY = TTY, IN_STR = STR)

rxnorm_in_map <- rxnorm_rel %>%
  select(RXCUI1, RXCUI2, RELA) %>%
  inner_join(rxnorm_in, by = c("RXCUI1" = "IN_RXCUI")) %>%
  filter(RELA %in% c("has_ingredient", "has_ingredients")) %>%
  inner_join(rxnorm_src, by=c("RXCUI2" = "RXCUI")) %>%
  select(IN_RXCUI = RXCUI1, IN_STR, IN_TTY,
         drug_code = RXCUI2, drug_name = STR, drug_type = TTY) %>%
  filter(drug_type %in% c("SCD", "SCDF", "SCDG", "SCDC", "DP"))

rxnorm_in_map <- rxnorm_rel %>%
  select(RXCUI1, RXCUI2, RELA) %>%
  inner_join(rxnorm_in_map, by = c("RXCUI1" = "drug_code")) %>%
  filter(RELA %in% c("consists_of", "dose_form_of", "doseformgroup_of",
                     "quantified_form_of", "tradename_of")) %>%
  inner_join(rxnorm_src, by=c("RXCUI2" = "RXCUI")) %>%
  select(IN_RXCUI, IN_STR, IN_TTY,
         drug_code = RXCUI2, drug_name = STR, drug_type = TTY) %>%
  filter(drug_type %in% c("SBD", "SCD")) %>%
  bind_rows(rxnorm_in_map) %>%
  unique()

rxnorm_in_map <- rxnorm_hcpcs %>%
  inner_join(rxnorm_in_map, by = c("RXCUI" = "drug_code")) %>%
  mutate(STR = NA, TTY = "HCPCS") %>%
  select(IN_RXCUI, IN_STR, IN_TTY,
         drug_code = HCPCS, drug_name = STR, drug_type = TTY) %>%
  bind_rows(rxnorm_in_map) %>%
  unique()

rxnorm_in_map <- rxnorm_attr %>%
  filter(ATN == "NDC") %>%
  select(RXCUI, NDC = ATV) %>%
  inner_join(rxnorm_in_map, by = c("RXCUI" = "drug_code")) %>%
  mutate(STR = NA, TTY = "NDC") %>%
  select(IN_RXCUI, IN_STR, IN_TTY,
         drug_code = NDC, drug_name = STR, drug_type = TTY) %>%
  bind_rows(rxnorm_in_map) %>%
  unique()

rxnorm_in_map %>%
  group_by(IN_TTY, drug_type) %>%
  count()

usethis::use_data(rxnorm_in, overwrite = TRUE)
usethis::use_data(rxnorm_in_map, overwrite = TRUE)
usethis::use_data(rxnorm_mesh_indications, overwrite = TRUE)
