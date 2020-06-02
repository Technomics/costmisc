
#' Clean "by" argument
#'
#' \code{clean_by()} takes a valid \code{by} input of a character vector (named or unnamed) and transforms
#' it into a list. Similar to \code{\link[dplyr]{common_by}} but does not require the actual data frames.
#'
#' @param by A character vector of variables to join by. Same specification as used in
#' \code{\link[dplyr]{join}}.\cr
#' \cr
#' To join by different variables on \code{df} and \code{df_sql} use a named vector.
#' For example, by = c("a" = "b") will match \code{df.a} to \code{df_sql.b}.
#'
#' @export
#'
clean_by <- function(by) {

  if (is.list(by) && names(by) == c("x", "y")) {
    by_col <- by
  } else if (is.null(names(by))) {
    by_col <- list(x = by, y = by)
  } else {
    by_col <- list(x = names(by), y = unname(by))
  }

  by_col
}
