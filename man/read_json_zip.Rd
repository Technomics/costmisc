% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_json_zip.R
\name{read_json_zip}
\alias{read_json_zip}
\title{Read all JSON files from a zip}
\usage{
read_json_zip(path, .warn_utf8_bom = TRUE)
}
\arguments{
\item{path}{Path to the .zip file.}

\item{.warn_utf8_bom}{Logical whether to report UTF8 byte-order-mark errors.}
}
\description{
\code{read_json_zip()} will read all JSON files from a zipped folder into a list of tibbles.
}
\seealso{
Other JSON list functions: 
\code{\link{write_json_zip}()}
}
\concept{JSON list functions}
