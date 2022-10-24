
#' Check file specification
#'
#' \code{check_spec()} will check a list of data against an expected file specification.
#'
#' @param table_list A list of data frames to check against the spec.
#' @param table_spec The table spec. See details.
#' @param type_label A character label for the check message.
#' @param .silent Logical whether or not to print results to the console.
#'
#' @return A list containing the results of the check.
#' @family Data Spec Functions
#'
#' @export
check_spec <- function(table_list, table_spec, type_label = "Import File", .silent = TRUE) {

  table_names <- names(table_list)
  check_table <- table_spec$tables %>%
    dplyr::pull(.data$table)

  # check table names
  unknown_tables <- table_names[!(table_names %in% check_table)]
  missing_tables <- check_table[!(check_table %in% table_names)]

  if (!.silent) {
    cli::cli_h1(paste(type_label, "Format Check"))
    cli::cat_line(c(paste("The following shows status of the", type_label, "against the File Format"),
                    "Specification. Some fields and tables are optional, so being missing",
                    "does not necessarily indicate a problem."))

    if (length(unknown_tables) > 0) {
      cli::cli_h2("Unknown Tables")
      cli::cat_bullet(unknown_tables)
      cli::cat_line("")
    }

    if (length(missing_tables) > 0) {
      cli::cli_h2("Missing Tables")
      cli::cat_bullet(missing_tables)
      cli::cat_line("")
    }

    cli::cli_h2(glue::glue("Individual Tables"))
  }

  # check field names
  check_field_names <- function(table, table_name) {

    field_names <- names(table)
    check_field <- table_spec$fields %>%
      dplyr::filter(.data$table == table_name) %>%
      dplyr::pull(.data$field)

    unknown_fields <- field_names[!(field_names %in% check_field)]
    missing_fields <- check_field[!(check_field %in% field_names)]

    if (!.silent) {
      if ((length(unknown_fields) == 0) && (length(missing_fields) == 0)) {
        cli::cli_alert_success(cli::style_bold(table_name))
      } else {
        cli::cli_alert_warning(cli::style_bold(table_name))
      }

      if (length(unknown_fields) > 0) {
        cli::cat_bullet(glue::glue("Unknown: {unknown_fields}"))
        cli::cat_line("")
      }
      if (length(missing_fields) > 0) {
        cli::cat_bullet(glue::glue("Missing: {missing_fields}"))
        cli::cat_line("")
      }
    }

    list(unknown = unknown_fields,
         missing = missing_fields)
  }

  field_check <- purrr::imap(table_list, check_field_names)

  list(tables = list(unknown = unknown_tables,
                     missing = missing_tables),
       fields = field_check)

}

#' Coerce data types to the specification
#'
#' @inheritParams check_spec
#' @param .fn_date function for converting the SQL "DATETIME" type. Default
#'   \code{as.Date()} will only work with ISO dates. See
#'   \link[janitor]{excel_numeric_to_date} for a convenient function for Excel
#'   numerics.
#'
#' @family Data Spec Functions
#'
#' @export
coerce_to_spec <- function(table_list, table_spec, .fn_date = as.Date) {

  # function to apply for a given SQL type
  r_to_sql_fns <- list(VARCHAR = as.character,
                       LONG = function(x) as.integer(readr::parse_number(as.character(x))),
                       DOUBLE = function(x) readr::parse_number(as.character(x)),
                       BIT = as.logical,
                       DATETIME = .fn_date)

  # function to alter a single table in the list
  coerce_table <- function(the_df, table_name) {

    # subset the field types
    table_fields <- table_spec$fields %>%
      dplyr::filter(table == table_name) %>%
      dplyr::select(.data$field, .data$type)

    # function to coerce all columns of a given type in the data frame
    coerce_to <- function(new_type, the_df) {
      the_cols <- dplyr::filter(table_fields, .data$type == new_type)$field
      if (length(the_cols) == 0) return(the_df)

      dplyr::mutate(the_df, dplyr::across(dplyr::any_of(the_cols), r_to_sql_fns[new_type], .names = "{.col}"))
    }

    # loop over each type - this accumulates so using a for loop (can use purrr::accumulate)
    for (current_type in names(r_to_sql_fns)) {
      the_df <- coerce_to(current_type, the_df)
    }

    the_df

  }

  purrr::imap(table_list, coerce_table)

}

#' Add missing columns from the specification
#'
#' @inheritParams check_spec
#' @param new_name Case in which the new names should be added. Must be a column from the \code{table_spec}.
#'
#' @family Data Spec Functions
#'
#' @export
add_missing_spec_cols <- function(table_list, table_spec, new_name = "snake_name") {

  sql_to_r_types <- tibble::tibble(VARCHAR = NA_character_,
                                   LONG = NA_integer_,
                                   DOUBLE = NA_real_,
                                   BIT = NA,
                                   DATETIME = NA_character_)

  # add any missing columns back in and rename
  add_missing_columns <- function(table, table_name) {
    field_spec <- table_spec$fields %>%
      dplyr::filter(table == table_name)

    # build a prototype list
    all_cols <- rlang::set_names(unclass(sql_to_r_types[field_spec$type]),
                                 field_spec$field)

    new_names <- rlang::set_names(field_spec$field, field_spec[[new_name]])

    tibble::add_column(table, !!!all_cols[setdiff(names(all_cols), names(table))]) %>%
      dplyr::select(tidyselect::all_of(names(all_cols))) %>%
      dplyr::rename(tidyselect::all_of(new_names))
  }

  purrr::imodify(table_list, add_missing_columns)
}

#' Add missing tables from the specification
#'
#' @inheritParams check_spec
#' @param checked_spec A return from \code{\link{check_spec}()}.
#'
#' @family Data Spec Functions
#'
#' @export
add_missing_spec_tables <- function(table_list, table_spec, checked_spec) {

  missing_tables <- purrr::set_names(checked_spec$tables$missing)

  # create the missing tables
  create_missing_table <- function(table_name) {

    col_names <- table_spec$fields %>%
      dplyr::filter(.data$table == table_name) %>%
      dplyr::pull(.data$field)

    tibble::as_tibble(sapply(col_names, function(x) logical()))
  }

  # set the data types
  new_tables <- coerce_to_spec(lapply(missing_tables, create_missing_table), table_spec)

  # append and return
  c(table_list, new_tables)
}


