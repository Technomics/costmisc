## ===== List Functions =====

#' Internal function to support stacking FlexFiles
#'
#' @description
#'
#' \code{unnest_df()} supports FlexFile stacking Internal function.
#'
#' @export
#'
#' @param .data A list of FlexFile submissions' tibbles converted from JSON format.
#'
#' @return A list of stacked tibbles of multiple dataframes
unnest_df <- function(.data) {
  purrr::flatten(.data) %>%
    split(., names(.)) %>%
    purrr::map(dplyr::bind_rows)
}

#' Add id column to a list
#'
#' @description
#'
#' \code{listindex_to_col()} adds the listindex from the first list of a list of data frames
#' as an ID column in each of the nested data frames.
#'
#' @export
#'
#'
#' @param .nestedlist A nested list of data frames.
#'
#' @examples
#' files <- system.file("extdata/multiple-flexfiles", package = "csdrtools")
#'
#' flexfiles <- read_folder(files, read_ff) %>%
#' listindex_to_col()
#'

listindex_to_col <- function(.nestedlist) {
  purrr::map(seq_along(.nestedlist), ~ add_id_col(.nestedlist[[.]], ., "ff_id"))
}

#' Add id column to dataframe
#'
#' @description
#'
#' \code{add_id_col()} adds an id column to either a data frame or to each data frame in a list.
#'
#' @export
#'
#'
#' @param .data A list of FlexFile submissions' tibbles converted from JSON format.
#' @param value A value to assign as the id.
#' @param var Character name of which to name the id column.
#'
#' @examples
#' file <- system.file("extdata", "Sample File_FF.zip", package = "csdrtools")
#'
#' flexfile <- read_ff(file) %>%
#' add_id_col()
#'

add_id_col <- function(.data, value = "1", var = "ff_id") {
  if (class(.data) == "data.frame") {
    tibble::add_column(.data, !!var := value, .before = 1)
  } else if (class(.data) == "list") {
    purrr::map(.data, ~ tibble::add_column(., !!var := value, .before = 1))
  }
}
