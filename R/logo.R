
#' @keywords internal
technomics_logo <- function(.color = TRUE) {

  text <- technomics_banner

  if (.color) {
    text <- cli::col_cyan(technomics_banner)
  }

  cli::cli_verbatim(text)
}

#' @keywords internal
costverse_logo <- function(pkg = NULL, .color = TRUE) {

  costverse <- costverse_banner
  technomics <- "Technomics, Inc."
  box_col <- "black"
  pack_name <- pkg


  if (.color) {
    costverse <- cli::col_magenta(costverse)
    technomics <- cli::col_cyan(technomics)
    pack_name <- cli::col_red(pack_name)
    box_col <- "silver"
  }

  top_line <- paste(technomics, pack_name,sep = "             ")

  cli::boxx(c(top_line,
              costverse),
            border_col = box_col)
}
