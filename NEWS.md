# costmisc 0.7.7

- Minor improvement to `coerce_to_spec()` adding 'INTEGER' alias to 'LONG' and 'BOOLEAN' alias to 'BIT'.

# costmisc 0.7.6

* Fixed a potential bug in `read_folder()`. Certain file paths on windows would fail a regex match. This normalizes the paths to avoid the error.

# costmisc 0.7.5

* Expanded data types in the various spec functions. Now includes 'INTEGER', 'BOOLEAN', 'DECIMAL', and 'LONGTEXT' as options to map back to the most appropriate R base data types (integer, logical, double, and character, respectively).

# costmisc 0.7.4

* Minor fixes to make functions some functions more compatible with dbplyr. This includes `add_missing_column()`.

# costmisc 0.7.3

* Fixed a bug with `assert_case()` when moving back to "native". In certain cases it was possible for the `data_case` attribute to be dropped. (#32)

# costmisc 0.7.2

* Added in the `validate_data()` generic.
* Fixed a bug related to the classes being dropped when changing case. (#28)

# costmisc 0.7.1

* Improved ability to work with different cases from the file spec.
  * Renamed the "base" case to "native" which is more descriptive. Adjusted functions to now refer to this "native" case as such instead of using the term "data model". This resulted in the name change of `data_model_to_snake()` and `snake_to_data_model()` to `native_to_snake_case()` and `snake_to_native_case()`, respectively.
  * Added in functions to pull the `data_case` and `data_spec` attributes from objects.
  * Added in function `assert_case()` to check if an object is in the correct case, and correct if needed. This should rarely be used. It is better to simply use one consistent case. However, some older packages applied an ill-advised naming convention, so this is used to improve the names but not break old code. (#23)

# costmisc 0.7.0

* Added in function `change_case_from_spec()` to allow easy changing of case from a file spec. Moved and re-factored code for `data_model_to_snake()` and `snake_to_data_model()` from `readflexfile` to utilize this new function.
* Added functions related to checking the file spec. This includes `check_spec()`, `coerce_to_spec()`, `add_missing_spec_cols()`, and `add_missing_spec_tables()`. This enables better usability throughout the costverse.

# costmisc 0.6.5

* Added the function `check_pkg_suggests()` to check if packages are installed for the user. (#7)

# costmisc 0.6.4

* Added the function `write_json_zip()` to write a list of tibbles into a zipped folder of JSON files.

# costmisc 0.6.3

* Moved the `flatten_data()` generic from readflexfile into costmisc. This should have no impact to the user.

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
