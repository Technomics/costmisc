
#' Read all JSON files from a zip
#'
#' \code{read_json_zip()} will read all JSON files from a zipped folder into a list of tibbles.
#'
#' @param path Path to the .zip file.
#'
#' @export
read_json_zip <- function(path) {

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
    json_list <- withCallingHandlers(jsonlite::parse_json(unz(path, zipped_filename)),
                                     warning = function(w) {
                                       if (grepl("UTF8 byte-order-mark!", w$message)) {
                                         utf_warnings[zipped_filename] <<- TRUE
                                         invokeRestart("muffleWarning")
                                       } else {
                                         message(w$message)
                                       }
                                     }
    )


    # loop through each value in the list, changing a NULL to NA
    fix_null <- function(x) {
      if (is.null(x)) x <- NA
      x
    }
    json_list_fixed <- purrr::map(json_list, ~ purrr::modify(.x, fix_null))

    # handle a list of rows or a single row
    f_flatten <- function(x) if (is.list(x)) purrr::flatten(x) else x

    # flatten the list to a dataframe
    purrr::map_dfr(json_list_fixed, f_flatten)
  }

  lst_json <- purrr::map(json_to_read, read_zip_file)

  if (any(utf_warnings))
    warning(paste("JSON string contains (illegal) UTF8 byte-order-mark in the following files:",
                  paste(names(utf_warnings)[utf_warnings], collapse = ", "), sep = "\n"))

  lst_json

}
