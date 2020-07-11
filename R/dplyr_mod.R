
#' Insensitive dplyr joins
#'
#' Function to wrap around the dplyr joins to make them insensitive to case. Author credit Jim Hester.\cr
#' \cr
#' \url{https://gist.github.com/jimhester/a060323a05b40c6ada34}
#'
#' @export
#'
#' @param fun Function from \code{dplyr::join} family.
#'
#' @seealso \code{\link[dplyr]{join}} and related functions from \code{dplyr}.
#'
#' @examples
#' \donttest{insensitive(left_join)(x, y)}
#'
insensitive <- function(fun = dplyr::inner_join) {
  new_fun <- fun
  body(new_fun) <- substitute({
    by <- dplyr::common_by(by, x, y)

    tmp_by_x <- paste0("_", by$x, "_")
    tmp_by_y <- paste0("_", by$y, "_")
    for (i in seq_along(by$x)) {
      x[[tmp_by_x[[i]]]] <- tolower(x[[by$x[[i]]]])
      y[[tmp_by_y[[i]]]] <- tolower(y[[by$y[[i]]]])
      y[[by$y[[i]]]] <- NULL
    }

    res <- fun(x, y, list(x = tmp_by_x, y = tmp_by_y), copy, suffix, ..., keep)
    res[tmp_by_x] <- list(NULL)

    res
  })

  new_fun
}

#' Insensitive dplyr distinct
#'
#' Alternative to \code{\link[dplyr]{distinct}} to operate insensitive to case. Parameters are defined identically to the
#' dplyr base function.
#'
#' @export
#'
#' @param .data See \code{\link[dplyr]{distinct}}.
#' @param ... See \code{\link[dplyr]{distinct}}.
#' @param .keep_all See \code{\link[dplyr]{distinct}}.
#'
#' @seealso \code{\link[dplyr]{distinct}} from \code{dplyr} for parameter definitions and function.
#'
distinct_insensitive <- function(.data, ..., .keep_all = FALSE) {
  col_names <- eval(quote(unlist(list(...))))
  if (is.null(col_names)) col_names <- colnames(.data)

  tmp_groups <- dplyr::group_vars(.data)

  tmp_data <- .data %>%
    dplyr::ungroup()

  tmp_distinct <- tmp_data %>%
    dplyr::mutate_all(tolower) %>%
    dplyr::select(col_names) %>%
    duplicated()

  tmp_data <- tmp_data %>%
    dplyr::slice((1:nrow(.))[! tmp_distinct])

  if (length(tmp_groups) > 0) dplyr::group_by_at(dplyr::vars(dplyr::one_of(tmp_groups)))

  if (! .keep_all) {
    tmp_data <- tmp_data %>%
      dplyr::select(col_names)
  }

  tmp_data
}
