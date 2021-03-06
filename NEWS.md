# costmisc 0.6.2

* Minor bug fix in `add_id_col()`. (#12)
* Added pattern matching and error handling to `read_folder()`. Files will now return `NULL` instead of throwing an error. (#1, #11)

# costmisc 0.6.1

* Added a new function `read_json_zip()` to read a folder of JSON files into a list of tibbles.

# costmisc 0.6.0

* First public release of costmisc! This package is available now on GitHub and is licensed under the GPLv3.

# costmisc 0.5.1

* Updated citation and copyright notifications.

# costmisc 0.5.0

* Moved the dplyr modification functions to another package. These were purposely removed rather than deprecated. This includes both `insensitive()` and `distinct_insensitive()`.

# costmisc 0.4.2

* Tweaked `insensitive()` so that it passes through all the join arguments.

# costmisc 0.4.1

* Added `add_missing_column()` to add a column if missing to a data frame.

# costmisc 0.4.0

* Added `get_excel_tables()` to view the Tables from an Excel workbook.
* Added `read_excel_table()` to read a Table from an Excel workbook.

# costmisc 0.3.0

* Moved in `clean_by()`, `paste_difftime()`, `insensitive()` and `distinct_insensitive()` from `ff2db`.

# costmisc 0.2.0

* Moved in `add_id_col()`, `listindex_to_col()`, `read_folder()` and `unnest_df()` from `csdrtools`.

# costmisc 0.1.0

* Moved in `as_int()` from `wbstools`.
* Moved in `strip_Attributes()` from `wbstools`.
