
<!-- README.md is generated from README.Rmd. Please edit that file -->

# costmisc

<!-- badges: start -->

[![technomics:
costverse](https://img.shields.io/badge/technomics-costverse-EAC435.svg)](https://github.com/technomics)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![coverage: 92%25](https://img.shields.io/badge/coverage-92%25-green.svg)](https://cran.r-project.org/web/packages/covr/vignettes/how_it_works.html)
[![License: GPL
v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![version:
0.6.0](https://img.shields.io/badge/version-0.6.0-blue.svg)]() [![R
build
status](https://github.com/Technomics/costmisc/workflows/R-CMD-check/badge.svg)](https://github.com/Technomics/costmisc/actions)
<!-- badges: end -->

The package costmisc adds miscellaneous functions to the costverse that
support various other packages.

Check out the [pkgdown](https://technomics.github.io/costmisc/) site to
browse the features\!

If you find a bug or have an idea for a new feature, please use the
[issue board](https://github.com/Technomics/costmisc/issues).

## Welcome to the costverse\!

The *costverse* is a collection of R packages, inspired by the
*tidyverse*. The goal is to create a cohesive ecosystem of R packages to
streamline tasks encountered by analysts in the cost analysis
profession. This can range from importing common data formats, working
with difficult data structures (e.g., a WBS), or applying more advanced
analytical techniques\!

The *costverse* began as an internal project by [Technomics Employee
Owners](https://www.technomics.net/) to develop a set of tools that we
actually want to use, to solve problems we are actually working on.
While aspects of the project still remain internal, the following
packages are currently available to the public. You are free to use them
under the [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html) - all
that we ask is to please cite us as the authors.

  - [costmisc](https://github.com/Technomics/costmisc/)
  - [readflexfile](https://github.com/Technomics/readflexfile/)

Do not hesitate to contact us if you have questions about what else is
in the works\!

## Installation

First install the package devtools if you haven’t already.

``` r
#install.packages("devtools")
devtools::install_github("Technomics/costmisc")
```

### Development version

To get a bug fix, or to use a feature from the development version, you
can install costmisc using the following.

``` r
devtools::dev_mode(on = TRUE)
devtools::install_github("Technomics/costmisc")
```
