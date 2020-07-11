
#' Add missing columns to a data frame
#'
#' \code{add_missing_column()} adds one or more columns to an existing data frame only if they
#' do not already exist.\cr
#' \cr
#' This is a simple wrapper around \code{\link[tibble]{add_column}()}.
#'
#' @export
#'
#' @inheritParams tibble::add_column
#'
#' @seealso \code{\link[tibble]{add_column}()}
#'
#' @examples
#' # add new columns x and y
#' add_missing_column(mtcars, x = 1, y = NA)
#'
#' # add new columns from a named vector
#' new_cols <- c(x = 1, y = NA)
#' add_missing_column(mtcars, !!!new_cols)
#'
add_missing_column <- function(.data, ..., .before = NULL, .after = NULL, .name_repair = c("check_unique", "unique", "universal", "minimal")) {
  .dots <- rlang::enquos(...)

  cols_to_add <- .dots[!names(.dots) %in% names(.data)]
  tibble::add_column(.data, !!!cols_to_add, .before = .before, .after = .after, .name_repair = .name_repair)
}
