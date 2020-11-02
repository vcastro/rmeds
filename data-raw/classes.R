# classes

class_graph <- read_delim("data-raw/19c09ef9cecef6e384b1d762c941f416.text", delim="|",
                         col_types = cols(.default = col_character()),
                         col_names = FALSE)

class_edges <- class_graph %>%
  filter(X10 == "isa") %>%
  select(classId1 = X8, classId2 = X12)

class_names <- class_graph %>%
  filter(X9 == "name") %>%
  select(classId = X8, name = X10, classType = X12) %>%
  unique()

class_hierachy <- class_edges %>%
  inner_join(class_names, by = c("classId1" = "classId")) %>%
  inner_join(class_names, by = c("classId2" = "classId")) %>%
  select(classId = classId1,
         parent_classId = classId2,
         className = name.x,
         parent_className = name.y,
         classType = classType.x) %>%
  unique()


### save batch config files: EPC, VA, ATC, graphs



##EPC
epc_classMembers <- read_delim("data-raw/41cdc77be8391ab91175c31dafbd0193.text",
                               delim="|",
                               col_types = cols(.default = col_character()),
                               col_names = paste0("X", 1:24)) %>%
  select(RXCUI = X15, STR = X14, classId = X20, className = X22, classType = X24) %>%
  filter(!is.na(RXCUI)) %>%
  unique()

##VA
va_classMembers <- read_delim("data-raw/4f3b501e3935992139dd09943827a427.text", delim="|",
                               col_types = cols(.default = col_character()),
                               col_names = paste0("X", 1:24)) %>%
  filter(X14 == "has_VAClass") %>%
  select(RXCUI = X12, STR = X10, TTY = X8, classId = X16, className = X18, classType = X6) %>%
  unique()  #MAP TO IN

##ATC
atc_classMembers <- read_delim("data-raw/64022166ca33a965e91bbe0d2e710fec.text", delim="|",
                              col_types = cols(.default = col_character()),
                              col_names = paste0("X", 1:24)) %>%
  filter(X6 == "ATC") %>%
  select(RXCUI = X12, STR = X10, TTY = X8, classId = X16, className = X18, classType = X6) %>%
  unique()
