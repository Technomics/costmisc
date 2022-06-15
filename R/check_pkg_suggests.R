
#' Check if Packages are Installed
#'
#' \code{check_pkg_suggests()} checks to see if packages are installed. This can be
#' used to check for the existence of packages in the Suggests line.
#'
#' @param pkg A vector of character package names.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' check_pkg_suggests(c("dplyr", "tidyr"))
#' check_pkg_suggests(c("dplyr", "tidyr", "notrealpackage", "alsofake"))
#' }
check_pkg_suggests <- function(pkg) {

  pkg_chk <- sapply(pkg, requireNamespace, quietly = TRUE)

  if (!all(pkg_chk)) {
    missing_pkg <- pkg[!pkg_chk]

    error_intro <- "Additional packages are required for this function to work. "
    install_line <- paste0("install.packages(c(", toString(paste0("\"", missing_pkg, "\"")), "))")

    stop(paste0(error_intro, "To install them all, run '", install_line, "'"), call. = FALSE)
  }

  invisible(TRUE)
}
