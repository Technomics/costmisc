## ===== Read Functions =====

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
  # need spec_type = base, readr, readxl
  str <- tolower(str)

  str_loc <- stringr::str_locate_all(str, "[a-z\\?\\-][0-9]+")[[1]]
  str_val <- stringr::str_sub(str, str_loc[,1], str_loc[,2])

  x_exp <- sapply(mapply(rep,
                         x = stringr::str_extract(str_val, "[a-z\\?\\-]"),
                         times = stringr::str_extract(str_val, "[0-9]+"),
                         SIMPLIFY = FALSE),
                  paste, collapse = "")

  expanded <- stringi::stri_sub_replace_all(str, str_loc[,1], str_loc[,2], replacement = x_exp)

  if (spec_type == "readr") {
    expanded
  } else if (spec_type == "readxl") {
    type_map <- c(c = "text", i = "numeric", n = "numeric", d = "numeric", l = "logical",
                  f = "text", D = "date", t = "date", "?" = "guess", "-" = "skip")

    chars <- unlist(strsplit(expanded, split = ""))
    unname(type_map[chars])
  }
}
