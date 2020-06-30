
#' Coerces to integer without warning
#'
#' \lifecycle{questioning}
#'
#' @param x object to coerce silently to integer.
#' @param na_regex regular expression of values to convert to \code{NA}.
#'
#' @export
#'
as_int <- function(x, na_regex = "[^0-9]") {
  x_na <- stringr::str_detect(x, na_regex)
  x[x_na] <- 0
  x <- as.integer(x)
  x[x_na] <- NA_integer_
  x
}

#' Strip attributes from object
#'
#' \lifecycle{questioning}
#'
#' @param x object to strip attributes from.
#' @param .retain_class logical whether or not to retain the class.
#'
#' @export
#'
strip_attributes <- function(x, .retain_class = TRUE) {
  x_class <- class(x)
  attributes(x) <- NULL

  if (.retain_class) structure(x, class = x_class) else x
}

#' Check is scalar type number
#'
#' \lifecycle{questioning}
#' This function was moved from \code{costmodelr}. The use case is unclear and as such this
#' function may be removed from a later version.\cr
#' \cr
#' \code{is_scalar_numeric()} checks for a given type and whether the vector is
#' "scalar", that is, of length 1.
#'
#' @inheritParams rlang::is_scalar_double
#'
#' @export
#'
#' @seealso \code{\link[rlang]{scalar-type-predicates}}
#'
is_scalar_numeric <- function(x) {
  rlang::is_scalar_double(x) || rlang::is_scalar_integer(x)
}
