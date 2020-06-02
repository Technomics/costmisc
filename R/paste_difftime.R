
#' Paste function for time difference
#'
#' \code{paste_difftime()} creates a message for an elapsed time. Taken from \code{print.difftime()}.
#'
#' @keywords internal
#'
#' @param x A timediff object.
#' @param time_msg The message prefix.
#' @param digits Number of digits option.
#'
paste_difftime <- function(x, time_msg = "Time difference of", digits = getOption("digits")) {
  paste0(time_msg, " ", format(unclass(x), digits = digits), " ", attr(x, "units"))
}
