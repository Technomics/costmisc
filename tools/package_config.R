
## ===== Project Setup ====

# Set name
options(usethis.full_name = "Adam H. James")

# Ignore folders on build
usethis::use_build_ignore("tools")

# Import badges for use in documentation
usethis::use_lifecycle()

# License
usethis::use_gpl3_license("Technomics, Inc.")

# Site
usethis::use_pkgdown()

## ===== DESCRIPTION =====

# Description list
description <- list(Description = "Package with miscellaneous functions used throughout the costverse.",
                    Title = "Misc costverse functions",
                    `Authors@R` = list(person(given = "Adam H.", family = "James",
                                              email = "ajames@technomics.net", role = c("cre", "aut"))))

# Run this to set description. It will replace whatever is there! Keep in mind the version before doing this.
# usethis::use_description(description)

usethis::use_data_raw()

# Package dependencies
#usethis::use_pipe()
usethis::use_package("cli", min_version = "2.0.0")
usethis::use_package("stringr", min_version = "1.4.0")
usethis::use_package("stringi", min_version = "1.4.0")
usethis::use_package("lifecycle")

## ===== README & NEWS =====

# Readme setup with RMarkdown
usethis::use_readme_rmd()
usethis::use_news_md()

usethis::use_lifecycle_badge("maturing")
usethis::use_badge("License: GPLv3", "https://opensource.org/licenses/GPL-3.0", "https://img.shields.io/badge/License-GPLv3-blue.svg")
rnomics::use_badge_passing()

## ===== Developmental Tools =====

devtools::build_site()
pkgdown::build_reference()

devtools::build_readme()
devtools::document()
devtools::spell_check()
devtools::check()

usethis::use_version()
rnomics::use_badge_version()

devtools::load_all()

devtools::build(binary = TRUE)
devtools::build()

detach("package:costmisc", unload = TRUE)

## ===== Scratch Work =====
