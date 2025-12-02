#' Add a package to the packages.R file
#'
#' This function adds a package to the `packages.R` file in the user's project
#' root. This makes the package available for use in the targets pipeline.
#'
#' @param package_name The name of the package to add.
#' @export
#' @examples
#' \dontrun{
#' add_package("ggplot2")
#' }
add_package <- function(package_name) {
  usethis::write_union("packages.R", paste0("library(", package_name, ")"))
}
