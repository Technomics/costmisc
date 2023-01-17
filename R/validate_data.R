#' Validate a data set
#'
#' A generic function that is used to validate data from a specialized read function
#' within the costverse.
#'
#' @param x A data object to validate.
#' @param ... Arguments passed on to methods.
#'
#' @export
validate_data <- function(x, ...) {
  UseMethod("validate_data")
}
