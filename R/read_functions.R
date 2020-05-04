## ===== Read Functions =====

#' Read of a folder of files
#'
#' @description
#'
#' \lifecycle{questioning}
#'
#' \cr
#' \code{read_folder()} is a wrapper around \code{lapply} to read an entire folder of files
#' into a list. No file checking is implemented, so each file in the target folder must be
#' of the same type.
#'
#' @export
#'
#'
#' @param folder A folder path to read.
#' @param read_function The function to use to read each file.
#' @param .clean_file_names Logical to clean names into snake_case or not.
#' @param .id Optionally add an id variable to each file table as this name.
#' @param ... Arguments passed to \code{read_function}.
#'
#' @return A list of read files from the folder.
#'
#' @examples
#' files <- system.file("extdata/multiple-flexfiles", package = "csdrtools")
#'
#' flexfiles <- read_folder(files, read_ff)
#'

read_folder <- function(folder, read_function, .clean_file_names = TRUE, .id = NULL, ...) {
  file_vector <- list.files(path = folder, full.names = TRUE, recursive = TRUE)

  file_list <- lapply(file_vector, read_function, ...)
  names(file_list) <- file_vector

  # don't love the name of .clean_file_names
  if (.clean_file_names) {
    names(file_list) <- janitor::make_clean_names(tolower(names(file_list)))
  }

  if (!is.null(.id)) {
    file_list <- listindex_to_col(file_list, .id)
  }

  file_list
}
