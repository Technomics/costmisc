
<!-- README.md is generated from README.Rmd. Please edit that file -->

# costmisc

<!-- badges: start -->

[![technomics:
costverse](https://img.shields.io/badge/technomics-costverse-EAC435.svg)](https://github.com/technomics)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![License: GPL
v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![R build
status](https://github.com/Technomics/costmisc/workflows/R-CMD-check/badge.svg)](https://github.com/Technomics/costmisc/actions)
[![version:
0.7.6](https://img.shields.io/badge/version-0.7.6-blue.svg)]()
[![coverage:
24.4%25](https://img.shields.io/badge/coverage-24.4%25-red.svg)](https://cran.r-project.org/web/packages/covr/vignettes/how_it_works.html)
<!-- badges: end -->

The package costmisc adds miscellaneous functions to the costverse that
support various other packages.

Check out the [pkgdown](https://technomics.github.io/costmisc/) site to
browse the features!

If you find a bug or have an idea for a new feature, please use the
[issue board](https://github.com/Technomics/costmisc/issues).

## Welcome to the costverse!

The *costverse* is a collection of R packages, inspired by the
*tidyverse*. The goal is to create a cohesive ecosystem of R packages to
streamline tasks encountered by analysts in the cost analysis
profession. This can range from importing common data formats, working
with difficult data structures (e.g., a WBS), or applying more advanced
analytical techniques!

The *costverse* began as an internal
[Technomics](https://www.technomics.net/) project to develop a set of
tools that enable our employee owners to solve our clients’ problems
more effectively. While aspects of the project remain internal, the
following packages are currently available to the public. You are free
to use them under the
[GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html) - all that we ask
is to please cite us as the authors.

- [costmisc](https://github.com/Technomics/costmisc/)
- [readflexfile](https://github.com/Technomics/readflexfile/)

Do not hesitate to contact us if you have questions about what else is
in the works!

## Installation

The stable version can be installed directly from the Technomics
repository.

``` r
install.packages("costmisc", repos = "https://technomics.github.io/repo/")
```

### Development version

To get a bug fix, or to use a feature from the development version, you
can install costmisc using the following.

First install the package devtools if you haven’t already.

``` r
#install.packages("devtools")

devtools::dev_mode(on = TRUE)
devtools::install_github("Technomics/costmisc")
```
