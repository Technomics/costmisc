#' Create a flat file from multiple data frames
#'
#' A generic function that is used to create a single flat file from a list of data
#' frames. This list is usually created by reading in a data format
#' with data spanning multiple tables.
#'
#' @param x A list of one or more collections of data frames to be flattened.
#' @param ... Arguments passed on to methods.
#'
#' @return A data frame with the flat file representation of the input data.
#'
#' @export
flatten_data <- function(x, ...) {
  UseMethod("flatten_data")
}
