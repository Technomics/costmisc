
#' Unnest identical data frames
#'
#' \code{unnest_df()} stacks a list of lists of dataframes. This assumes that each
#' level 2 list has the same dataframes with the same columns. This is used when
#' reading in a set of files with identical format.
#'
#' @export
#'
#' @param .data A list of lists of dataframes.
#'
#' @return A list of stacked tibbles.
#' @seealso \code{\link{listindex_to_col}}
#'
unnest_df <- function(.data) {
  purrr::flatten(.data) %>%
    split(., names(.)) %>%
    purrr::map(dplyr::bind_rows)
}

#' Add id column to dataframe
#'
#' \code{add_id_col()} adds an id column to either a data frame or to each data frame in a list.
#'
#' @export
#'
#' @param .data A list (or list of lists) of data frames.
#' @param value A value to assign as the id.
#' @param var Character name of the new id column.
#'
add_id_col <- function(.data, value = "1", var = "doc_id") {
  if (class(.data) == "data.frame") {
    tibble::add_column(.data, !!var := value, .before = 1)
  } else if (class(.data) == "list") {
    purrr::map(.data, ~ tibble::add_column(., !!var := value, .before = 1))
  }
}

#' Add id columns to dataframes
#'
#' \code{listindex_to_col()} adds the listindex from the first list of a list of data frames
#' as an ID column in each of the nested data frames.
#'
#' @export
#' @rdname add_id_col
#' @seealso \code{\link{unnest_df}}
#'
listindex_to_col <- function(.data, var = "doc_id") {
  purrr::map(seq_along(.data), ~ add_id_col(.data[[.]], ., var))
}
