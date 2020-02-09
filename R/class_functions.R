#' Coerces to integer without warning
#'
#' \lifecycle{questioning}
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
#' @export
#'
strip_attributes <- function(x, .retain_class = TRUE) {
  x_class <- class(x)
  attributes(x) <- NULL

  if (.retain_class) structure(x, class = x_class) else x
}
