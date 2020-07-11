
#' Read of a folder of files
#'
#' @description
#'
#' \code{read_folder()} is a wrapper around \code{lapply} to read an entire folder of files
#' into a list. No file checking is implemented, so each file in the target folder must be
#' of the same type.
#'
#' @export
#'
#' @param folder A folder path to read.
#' @param read_function The function to use to read each file.
#' @param .clean_file_names Logical to clean names into snake_case or not.
#' @param .id Optionally add an id variable to each file table as this name
#' @param .recursive Logical to recursively load the folder.
#' @param ... Arguments passed to \code{read_function}.
#'
#' @return A list of output from the `read_function`.
#'
read_folder <- function(folder, read_function, .clean_file_names = TRUE,
                        .id = NULL, .recursive = TRUE, ...) {

  file_vector <- list.files(path = folder, full.names = TRUE, recursive = .recursive)
  file_names <- stringr::str_remove(file_vector, folder)

  file_list <- lapply(file_vector, read_function, ...)
  names(file_list) <- file_names

  if (.clean_file_names) {
    names(file_list) <- janitor::make_clean_names(tolower(names(file_list)))
  }

  if (!is.null(.id)) {
    file_list <- listindex_to_col(file_list, .id)
  }

  file_list
}

#' Simple column specifications
#'
#' \code{col_rep()} allows for a simple specification of column types for use in read
#' functions. Enter in a letter followed by a number to repeat that type that number
#' of times. \cr
#' \cr
#' Supports output for use in \code{readr} and \code{readxl}, and other functions
#' that take column type specifications in the same format.
#'
#' @param str String specifying the expansion.
#' @param spec_type String. Either "readr" for short letter notation (e.g.,
#' \code{ccnnndcc}) or "readxl" for long vector notation
#' (e.g., \code{c("text", "text", "numeric")})
#'
#' @return An expanded string or a vector of column type specifications.
#' @export
#'
#' @examples
#' col_rep("c3n2dl3-2c")
#'
#' col_rep("c3n2dl3-2c", "readxl")
#'
col_rep <- function(str, spec_type = "readr") {
  # need spec_type = base, readr, readxl, sql

  str_loc <- stringr::str_locate_all(str, "[A-z\\?\\-][0-9]+")[[1]]

  if (nrow(str_loc) > 0) {
    str_val <- stringr::str_sub(str, str_loc[,1], str_loc[,2])

    x_exp <- sapply(mapply(rep,
                           x = stringr::str_extract(str_val, "[A-z\\?\\-]"),
                           times = stringr::str_extract(str_val, "[0-9]+"),
                           SIMPLIFY = FALSE),
                    paste, collapse = "")

    expanded <- stringi::stri_sub_replace_all(str, str_loc[,1], str_loc[,2], replacement = x_exp)
  } else {
    expanded <- str
  }

  if (spec_type == "readr") return(expanded)

  type_map <- list(readxl = c(c = "text", i = "numeric", n = "numeric", d = "numeric", l = "logical",
                              f = "text", D = "date", t = "date", "?" = "guess", "-" = "skip"),
                   sql = c(c = "VARCHAR", i = "INTEGER", n = "DOUBLE", d = "DOUBLE", l = "BIT",
                           f = "VARCHAR", D = "DATETIME", t = "DATETIME", "?" = NA_character_, "-" = NA_character_,
                           a = "COUNTER"))

  chars <- unlist(strsplit(expanded, split = ""))
  unname(type_map[[spec_type]][chars])
}


#' List Excel tables in a workbook
#'
#' \code{get_excel_tables()} is similar to \code{\link[openxlsx]{getTables}()} but
#' returns more information.
#'
#' @inheritParams openxlsx::getTables
#' @param sheets Character vector of sheet names to list tables from. If `NULL`,
#' lists all sheets.
#'
#' @return A tibble with the worksheet, table name, and cell references.
#' @export
#'
#' @family Read Excel tables
#'
#' @examples
#' example_file <- system.file("examples/excel examples.xlsx", package = "costmisc")
#'
#' wb <- openxlsx::loadWorkbook(example_file)
#' get_excel_tables(wb)
#'
get_excel_tables <- function(wb, sheets = NULL) {

  if (!requireNamespace("openxlsx", quietly = TRUE))
    stop("Package \"openxlsx\" needed for this function to work. Please install it.")

  if (is.null(sheets))
    sheets <- names(wb)

  sheets %>%
    purrr::map_df( ~ {
      tbls <- openxlsx::getTables(wb, .)
      tibble::tibble(sheet = .,
                     table = strip_attributes(tbls, FALSE),
                     range = attr(tbls, "refs"))
    })
}

#' Read Excel tables
#'
#' \code{read_excel_table()} reads a table object from an Excel workbook.
#'
#' @inheritParams openxlsx::getTables
#' @param table_name A character name of a table to read.
#' @param table_df A dataframe of table references, built using
#' \code{\link{get_excel_tables}()}. If `NULL` the table will be built.
#'
#' @return A tibble with the table.
#' @export
#'
#' @family Read Excel tables
#'
#' @examples
#' example_file <- system.file("examples/excel examples.xlsx", package = "costmisc")
#'
#' wb <- openxlsx::loadWorkbook(example_file)
#' head(read_excel_table(wb, "tbl_mtcars"))
#'
read_excel_table <- function(wb, table_name, table_df = NULL) {

  if (!requireNamespace("openxlsx", quietly = TRUE))
    stop("Package \"openxlsx\" needed for this function to work. Please install it.")

  if (is.null(table_df))
    table_df <- get_excel_tables(wb)

  range <- table_df %>%
    dplyr::filter(table == table_name) %>%
    dplyr::select(sheet, range)

  if (nrow(range) != 1) stop(paste0("Table \"", table_name, "\" not uniquely found"))

  parse_range <- function(range) {
    cells <- stringr::str_split(range, ":", simplify = T)
    colrange <- openxlsx::convertFromExcelRef(cells)
    rowrange <- stringr::str_remove(cells, "[^0-9]")

    list(cols = colrange[1]:colrange[2],
         rows = rowrange[1]:rowrange[2])
  }

  read_cells <- parse_range(range[[2]])

  openxlsx::readWorkbook(wb, sheet = range[[1]], rows = read_cells$rows, cols = read_cells$cols)
}
