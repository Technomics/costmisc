% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check_spec.R
\name{add_missing_spec_cols}
\alias{add_missing_spec_cols}
\title{Add missing columns from the specification}
\usage{
add_missing_spec_cols(table_list, table_spec, new_name = "snake_name")
}
\arguments{
\item{table_list}{A list of data frames to check against the spec.}

\item{table_spec}{The table spec. See details.}

\item{new_name}{Case in which the new names should be added. Must be a column from the \code{table_spec}.}
}
\description{
Add missing columns from the specification
}
\seealso{
Other Data Spec Functions: 
\code{\link{add_missing_spec_tables}()},
\code{\link{assert_case}()},
\code{\link{change_case_from_spec}()},
\code{\link{check_spec}()},
\code{\link{coerce_to_spec}()},
\code{\link{data_case}()}
}
\concept{Data Spec Functions}
