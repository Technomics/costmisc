
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
#' example_file <- system.file("examples/excel_examples.xlsx", package = "costmisc")
#'
#' wb <- openxlsx::loadWorkbook(example_file)
#' get_excel_tables(wb)
#'
get_excel_tables <- function(wb, sheets = NULL) {

  if (!requireNamespace("openxlsx", quietly = TRUE))
    stop("Package \"openxlsx\" needed for this function to work. Please install it.")

  if (is.null(sheets))
    sheets <- names(wb)

  purrr::map_df(sheets, ~ {
    tbls <- openxlsx::getTables(wb, .x)
    tibble::tibble(sheet = .x,
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
#' example_file <- system.file("examples/excel_examples.xlsx", package = "costmisc")
#'
#' wb <- openxlsx::loadWorkbook(example_file)
#' head(read_excel_table(wb, "tbl_mtcars"))
#'
read_excel_table <- function(wb, table_name, table_df = NULL) {

  if (!requireNamespace("openxlsx", quietly = TRUE))
    stop("Package \"openxlsx\" needed for this function to work. Please install it.")

  if (is.null(table_df))
    table_df <- get_excel_tables(wb)

  range <- dplyr::select(dplyr::filter(table_df, .data$table == table_name), "sheet", "range")

  if (nrow(range) != 1) stop(paste0("Table \"", table_name, "\" not uniquely found"))

  parse_range <- function(range) {
    cells <- stringr::str_split(range, ":", simplify = T)
    colrange <- openxlsx::convertFromExcelRef(cells)
    rowrange <- stringr::str_remove_all(cells, "[^0-9]")

    list(cols = colrange[1]:colrange[2],
         rows = rowrange[1]:rowrange[2])
  }

  read_cells <- parse_range(range[[2]])

  openxlsx::readWorkbook(wb, sheet = range[[1]], rows = read_cells$rows, cols = read_cells$cols)
}
