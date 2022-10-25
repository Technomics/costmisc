
#' Format contract number
#'
#' \code{format_contract()} takes in a single contract number and returns a consistently-formatted
#' contract number, according to user controls for the output.
#'
#' @param contract Character string, contract number.
#' @param hyphenated,master_only  Logical, options for controlling the _output_.
#'   \code{master_only} returns only the parent contract.
#'
#' @return A character string in the specified format.
#'
#' @examples
#' # control the output with the two logical parameters
#' format_contract("FA8616-14-D-6060:0001",
#'                 hyphenated = TRUE,
#'                 master_only = FALSE)
#' format_contract("FA8620-15-G-4040-0039",
#'                 hyphenated = TRUE,
#'                 master_only = TRUE)
#' format_contract("FA8620-15-G-4040-FA8620-15-F-4040",
#'                 hyphenated = FALSE,
#'                 master_only = TRUE)
#' format_contract("FA862015C4040",
#'                 hyphenated = FALSE,
#'                 master_only = FALSE)
#'
#' @export
format_contract <- function(contract, hyphenated = TRUE, master_only = FALSE) {

  ### writing to take a single contract number
  ### easier for logic to be applied to each one

  # abort function for NAs
  if (is.na(contract)) return(NA_character_)

  # normalize all contracts to non-hyphenated version
  con_no_hyph <- stringr::str_squish(contract) %>%
    stringr::str_remove_all("[^\\dA-z]")

  # boolean for if the contract has a DO with it
  has_DO <- stringr::str_length(con_no_hyph) > 13

  # separate master contract from DO
  if (has_DO) {

    con_master <- stringr::str_sub(con_no_hyph, 1, 13)

    if (!master_only) {
      DO <- stringr::str_sub(con_no_hyph, 14, stringr::str_length(con_no_hyph))
    }

  } else {
    con_master <- con_no_hyph
  }

  # format master contract number based on user selections
  if (hyphenated) {
    master_formatted <- paste(stringr::str_sub(con_no_hyph, 1, 6),
                              stringr::str_sub(con_no_hyph, 7, 8),
                              stringr::str_sub(con_no_hyph, 9, 9),
                              stringr::str_sub(con_no_hyph, 10, 13),
                              sep = "-")
  } else {
    master_formatted <- con_master
  }

  # format DO based on user selections
  if (master_only | !has_DO) {
    return(master_formatted)
  } else {

    is_long_DO <- stringr::str_length(DO) > 4

    # hyphenate long DOs
    if (is_long_DO & hyphenated) {
      DO_formatted <- paste(stringr::str_sub(DO, 1, 6),
                            stringr::str_sub(DO, 7, 8),
                            stringr::str_sub(DO, 9, 9),
                            stringr::str_sub(DO, 10, 13),
                            sep = "-")
    } else {
      DO_formatted <- DO
    }
  }

  # put master and DO together
  if (hyphenated) {
    final_formatted <- paste(master_formatted, DO_formatted, sep = "-")
  } else {
    final_formatted <- paste(master_formatted, DO_formatted, sep = "")
  }

  final_formatted

}
