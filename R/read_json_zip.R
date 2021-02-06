
#' Read all JSON files from a zip
#'
#' \code{read_json_zip()} will read all JSON files from a zipped folder into a list of tibbles.
#'
#' @param path Path to the .zip file.
#' @param .warn_utf8_bom Logical whether to report UTF8 byte-order-mark errors.
#'
#' @export
read_json_zip <- function(path, .warn_utf8_bom = TRUE) {

  zip_contents <- zip::zip_list(path)

  # process contents of the zip folder
  json_files_all <- dplyr::transmute(zip_contents,
                                     dir = fs::path_dir(.data$filename),
                                     file = fs::path_file(.data$filename),
                                     ext = fs::path_ext(.data$filename),
                                     basename = fs::path_ext_remove(.data$file))

  json_files <- dplyr::filter(json_files_all,
                              .data$dir == ".", .data$ext == "json")

  json_to_read <- rlang::set_names(json_files$file, json_files$basename)
  utf_warnings <- rlang::set_names(rep(FALSE, length(json_to_read)), json_to_read)

  # function to read a single zip file
  read_zip_file <- function(zipped_filename) {

    # collect UTF8 BOM errors for later
    json_input <- withCallingHandlers(
      jsonlite::parse_json(unz(path, zipped_filename), simplifyVector = TRUE),
      warning = function(w) {
        if (grepl("UTF8 byte-order-mark!", w$message)) {
          utf_warnings[zipped_filename] <<- TRUE
          invokeRestart("muffleWarning")
        } else {
          message(w$message)
        }
      }
    )

    # if a list (i.e., could not simplify), then must replace NULLs
    fix_json_null(json_input)
  }

  lst_json <- purrr::map(json_to_read, read_zip_file)

  if (any(utf_warnings) & .warn_utf8_bom)
    warning(paste("JSON string contains (illegal) UTF8 byte-order-mark in the following files:",
                  paste(names(utf_warnings)[utf_warnings], collapse = ", "), sep = "\n"))

  lst_json

}

#' Fix 'null' values in JSON
#'
#' \code{fix_json_null()} replaces 'null' values in the JSON with an NA. This
#' is needed for single row tables in the JSON with a null value. In this case,
#' \code{\link[jsonlite]{read_json}(..., simplifyVector = FALSE)} returns a list instead
#' of a data.frame because of the 'null'. This function takes that list, replaces the 'null'
#' with an \code{NA} and returns the data.frame.
#'
#' @param json_object An object read in from \code{read_json()}.
#'
#' @return A corrected tibble with \code{NA} in place of the null.
#' @export
#'
fix_json_null <- function(json_object) {

  if (!is.data.frame(json_object)) {
    purrr::map_dfc(json_object, fix_null)
  } else {
    dplyr::as_tibble(json_object)
  }

}

#' @keywords internal
fix_null <- function(x) if (is.null(x)) NA else x
