% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_functions_excel.R
\name{read_excel_table}
\alias{read_excel_table}
\title{Read Excel tables}
\usage{
read_excel_table(wb, table_name, table_df = NULL)
}
\arguments{
\item{wb}{A workbook object}

\item{table_name}{A character name of a table to read.}

\item{table_df}{A dataframe of table references, built using
\code{\link{get_excel_tables}()}. If \code{NULL} the table will be built.}
}
\value{
A tibble with the table.
}
\description{
\code{read_excel_table()} reads a table object from an Excel workbook.
}
\examples{
example_file <- system.file("examples/excel_examples.xlsx", package = "costmisc")

wb <- openxlsx::loadWorkbook(example_file)
head(read_excel_table(wb, "tbl_mtcars"))

}
\seealso{
Other Read Excel tables: 
\code{\link{get_excel_tables}()}
}
\concept{Read Excel tables}
