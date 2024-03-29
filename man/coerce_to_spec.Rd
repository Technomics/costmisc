% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check_spec.R
\name{coerce_to_spec}
\alias{coerce_to_spec}
\title{Coerce data types to the specification}
\usage{
coerce_to_spec(table_list, table_spec, .fn_date = as.Date)
}
\arguments{
\item{table_list}{A list of data frames to check against the spec.}

\item{table_spec}{The table spec. See details.}

\item{.fn_date}{function for converting the SQL "DATETIME" type. Default
\code{as.Date()} will only work with ISO dates. See
\link[janitor]{excel_numeric_to_date} for a convenient function for Excel
numerics.}
}
\description{
Coerce data types to the specification
}
\seealso{
Other Data Spec Functions: 
\code{\link{add_missing_spec_cols}()},
\code{\link{add_missing_spec_tables}()},
\code{\link{assert_case}()},
\code{\link{change_case_from_spec}()},
\code{\link{check_spec}()},
\code{\link{data_case}()}
}
\concept{Data Spec Functions}
