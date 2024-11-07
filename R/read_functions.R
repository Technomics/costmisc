
#' Read of a folder of files
#'
#' \code{read_folder()} is a wrapper around \code{lapply} to read an entire folder of files
#' into a list. A \code{NULL} is returned if the file is unable to be read.
#'
#' @export
#'
#' @param folder A folder path to read.
#' @param read_function The function to use to read each file.
#' @param pattern An optional \link{regex}. Only file names which match the regular expression will be read.
#' @param .clean_file_names Logical to clean names into snake_case or not.
#' @param .basename Logical to only keep the \code{\link{basename}()} of each file.
#' @param .id Character. Optionally add an id variable to each table, named as this value.
#' @param .recursive Logical to recursively load the folder.
#' @param ... Arguments passed to \code{read_function}.
#'
#' @return A list of output from the `read_function`. A \code{NULL} is returned if the file is
#' unable to be read.
#'
read_folder <- function(folder, read_function, pattern = NULL, .clean_file_names = TRUE, .basename = FALSE,
                        .id = NULL, .recursive = TRUE, ...) {

  .path = normalizePath(folder, winslash = "/")

  file_vector <- list.files(path = .path, pattern = pattern, full.names = TRUE, recursive = .recursive)
  file_names <- stringr::str_remove(file_vector, stringr::fixed(.path))
  if (.basename) file_names <- basename(file_names)

  read_function_try <- function(x, ...) {
    tryCatch(read_function(x, ...),
             error = function(e) {
               warning(paste("cannot read file:", x))
               return(NULL)
             })
  }


  file_list <- lapply(file_vector, read_function_try, ...)
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


