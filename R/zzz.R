
# .onAttach <- function(libname, pkgname) {
#   packageStartupMessage(costverse_logo(pkgname))
# }

.onAttach <- function(libname, pkgname) {
  start_msg <- paste0("costverse::", pkgname, ". Copyright \U00A9 2024 by Technomics, Inc. Licensed under GPLv3",
                      "\n\n",
                      "Run 'citation(\"", pkgname, "\")' for information on how to cite in your own work.")

  packageStartupMessage(start_msg)
}
