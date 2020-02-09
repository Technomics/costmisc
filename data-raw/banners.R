

## Technomics

technomics_banner <- readLines("data-raw/technomics_banner.txt")

usethis::use_data(technomics_banner, internal = TRUE, overwrite = TRUE)

## Costverse

costverse_banner <- readLines("data-raw/costverse_banner.txt")

usethis::use_data(costverse_banner, internal = TRUE, overwrite = TRUE)
