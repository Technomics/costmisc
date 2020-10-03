
## ===== Project Setup ====

# Set name
options(usethis.full_name = "Adam H. James")

# Ignore folders on build
usethis::use_build_ignore("tools")

# Import badges for use in documentation
usethis::use_lifecycle()

# License
usethis::use_gpl3_license("Technomics, Inc")

# Site
usethis::use_pkgdown()

# Test
usethis::use_testthat()
usethis::use_test("read_functions")

# Citation
usethis::use_citation()

# GitHub
usethis::use_github_actions() # this includes the standard R-CMD-check
usethis::use_github_action()

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
usethis::use_pipe()
usethis::use_package("cli", min_version = "2.0.0")
usethis::use_package("stringr", min_version = "1.4.0")
usethis::use_package("stringi", min_version = "1.4.0")
usethis::use_package("rlang", min_version = "0.4.6")
usethis::use_package("dplyr", min_version = "0.8.5")
usethis::use_package("tibble", min_version = "3.0.0")
usethis::use_package("purrr", min_version = "0.3.3")
usethis::use_package("janitor", min_version = "2.0.0")

usethis::use_package("openxlsx", min_version = "4.1.4", type = "Suggests")

usethis::use_package("lifecycle")

## ===== README & NEWS =====

# Readme setup with RMarkdown
usethis::use_readme_rmd()
usethis::use_news_md()

rnomics::use_badge_costverse()
usethis::use_lifecycle_badge("maturing")
rnomics::use_badge_prop()
rnomics::use_badge_passing()

## ===== Developmental Tools =====

cvg <- devtools::test_coverage()
rnomics::use_badge_coverage(cvg)
devtools::test()

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


