
#' Convert table name and field case
#'
#' \code{change_case_from_spec()} renames from one case to another from the file spec.
#'
#' @details This function relies on names from a spec file. In order for this to work
#' consistently, a few things are assumed.\cr
#' \cr
#' The 'native' case tables are specified by the column named 'table' in both the 'tables'
#' and 'fields' data frames of the spec. The fields for the native case are specified by the
#' column named 'field' in the 'fields data frame of the spec.\cr
#' \cr
#' Any other valid case (e.g., 'new_case') specifies the table name in the 'tables' data
#' frame with the suffix "_table" (e.g., 'new_case_table'). The field names are specified in
#' the 'fields' table with the suffix "_name" (e.g., 'new_case_name').\cr
#' \cr
#' To access this specific case for conversion, simply use 'new_case' as the argument value for
#' either \code{from_case} or \code{to_case}.
#'
#' @param table_list A list of tables to rename.
#' @param table_spec Data model specification object.
#' @param from_case String name of the case the object originates from. If \code{NULL},
#' defaults to the 'native' case.
#' @param to_case String name of the case to convert to. If \code{NULL},
#' defaults to the 'native' case.
#' @param add_missing Logical whether to add in missing tables and columns.
#' @param add_missing_by_type Character vector of values from the spec 'type' column.
#' Only tables of this type will be added back in if \code{add_missing = TRUE}.
#'
#' @family Data Spec Functions
#'
#' @export
change_case_from_spec <- function(table_list, table_spec,
                                  from_case = NULL, to_case = NULL,
                                  add_missing = FALSE,
                                  add_missing_by_type = NULL) {

  if (!identical(names(table_spec), c("tables", "fields")))
    stop("Invalid 'table_spec'.")

  original_table_list <- table_list

  if (is.null(from_case)) {
    from_table_name <- "table"
    from_field_name <- "field"
  } else {
    from_table_name <- paste0(from_case, "_table")
    from_field_name <- paste0(from_case, "_name")
  }

  if (is.null(to_case)) {
    to_table_name <- "table"
    to_field_name <- "field"
  } else {
    to_table_name <- paste0(to_case, "_table")
    to_field_name <- paste0(to_case, "_name")
  }

  # rename fields
  rename_columns <- function(table, table_name, from_name, to_name) {
    field_spec <- table_spec$fields %>%
      dplyr::filter(.data$table == table_name)

    # vector of new names
    new_names <- rlang::set_names(field_spec[[from_name]], field_spec[[to_name]])

    table %>%
      dplyr::rename(tidyselect::any_of(new_names))
  }

  # if there is a from_case, move table names back to base
  if (!is.null(from_case)) {
    base_table_names <- rlang::set_names(table_spec$tables$table,
                                         table_spec$tables[[from_table_name]])
    names(table_list) <- base_table_names[names(table_list)]
  }

  # change field names
  if (isTRUE(add_missing)) {
    # to add in missing, we need to round trip it back to native first

    # if there is a from_case, take back to the native case
    if (!is.null(from_case)) {
      table_list <- purrr::imodify(table_list, rename_columns, from_name = from_field_name, to_name = "field")
    }

    # the check is required to add in missing
    check <- check_spec(table_list, table_spec,
                        .silent = TRUE,
                        .include_table_type = add_missing_by_type)

    # add in the missing tables and columns in the native case
    table_list <- table_list %>%
      add_missing_spec_tables(table_spec, check) %>%
      add_missing_spec_cols(table_spec, new_name = "field")

    # if there is a to_case, round trip the field names to this
    if (!is.null(to_case)) {
      table_list <- purrr::imodify(table_list, rename_columns, from_name = "field", to_name = to_field_name)
    }

  } else {
    # if not adding in missing, can just take the fields directly to the end state
    table_list <- purrr::imodify(table_list, rename_columns, from_name = from_field_name, to_name = to_field_name)
  }

  # if there is a to_case, move table names into this case
  if (!is.null(to_case)) {
    final_table_names <- rlang::set_names(table_spec$tables[[to_table_name]],
                                          table_spec$tables$table)
    names(table_list) <- final_table_names[names(table_list)]
  }

  # assign attributes
  table_list <- copy_attributes_spec(original_table_list, table_list)
  attr(table_list, "data_case") <- ifelse(is.null(to_case), "native", to_case)

  table_list

}

#' Convert table names
#'
#' \code{native_to_snake_case()} is a convenience wrapper around \code{\link{change_case_from_spec}()}
#' to convert from native case to snake_case. This function will also add any missing columns
#' from the spec to the model.
#'
#' @rdname change_case_from_spec
#'
#' @export
native_to_snake_case <- function(table_list, table_spec = data_spec(table_list)) {

  change_case_from_spec(table_list, table_spec,
                        from_case = NULL, to_case = "snake",
                        add_missing = TRUE,
                        add_missing_by_type = "submission")

}

#' Convert table names
#'
#' \code{snake_to_native_case()} is a convenience wrapper around \code{\link{change_case_from_spec}()}
#' to convert from snake_case to the native case.
#'
#' @rdname change_case_from_spec
#'
#' @export
snake_to_native_case <- function(table_list, table_spec = data_spec(table_list)) {

  change_case_from_spec(table_list, table_spec,
                        from_case = "snake", to_case = NULL,
                        add_missing = FALSE)

}

#' Convert table names
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `data_model_to_snake()` was renamed to `native_to_snake_case()` to make the function
#' general in name.
#'
#' @keywords internal
#' @export
data_model_to_snake <- function(table_list, table_spec) {

  lifecycle::deprecate_warn("0.7.1", "data_model_to_snake()", "native_to_snake_case()")

  native_to_snake_case(table_list, table_spec)
}

#' Convert table names
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `snake_to_data_model()` was renamed to `snake_to_native_case()` to make the function
#' general in name.
#'
#' @keywords internal
#' @export
snake_to_data_model <- function(table_list, table_spec) {

  lifecycle::deprecate_warn("0.7.1", "snake_to_data_model()", "snake_to_native_case()")

  snake_to_native_case(table_list, table_spec)

}
