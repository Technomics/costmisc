
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
usethis::use_github_action("pkgdown")

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
usethis::use_package("tidyselect", min_version = "1.1.2")
usethis::use_package("purrr", min_version = "0.3.3")
usethis::use_package("janitor", min_version = "2.0.0")
usethis::use_package("glue", min_version = "1.6.0")
usethis::use_package("readr", min_version = "2.0.0")
usethis::use_package("fs", min_version = "1.4.1")
usethis::use_package("jsonlite", min_version = "1.6.1")
usethis::use_package("zip", min_version = "2.1.1")

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

devtools::document()
devtools::spell_check()
devtools::check()

usethis::use_version()
rnomics::use_badge_version()

devtools::load_all()

detach("package:costmisc", unload = TRUE)

## ===== Build =====

build_path_root <- file.path(setupr::get_dirs()$git_local, "costverse", "_builds")
build_path <- list(bin = file.path(build_path_root, "bin", rnomics::r_version()),
                   src = file.path(build_path_root, "src"))

fs::dir_create(unlist(build_path))

bin_build_file <- devtools::build(binary = TRUE, path = build_path$bin)
src_build_file <- devtools::build(path = build_path$src)

drat_repo <- file.path(setupr::get_dirs()$git_local, "costverse", "repo")
rnomics::add_to_drat(c(bin_build_file, src_build_file), drat_repo)

## ===== Scratch Work =====

