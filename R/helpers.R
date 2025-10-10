contains_rmarkdown <- function(filepath) {

  libs_file_lines <-
    readr::read_lines(filepath)

  any(grepl("^library\\(rmarkdown\\)", libs_file_lines))

}

contains_quarto <- function(filepath) {

  libs_file_lines <-
    readr::read_lines(filepath)

  any(grepl("^library\\(quarto\\)", libs_file_lines))

}

current_plan_yaml_entry <- function() {
  yaml_file <- parse_targets_yaml()
  current_file <- rstudioapi::getActiveDocumentContext()$path

  yaml_entry <-
    yaml_file[fs::path_real(yaml_file$script) == fs::path_real(current_file), ]

  if (nrow(yaml_entry) == 0) stop("{tflow} could't find an entry for current active source file in _targets.yaml")
  if (nrow(yaml_entry) > 1) stop("{tflow} found more than one entry in _targets.yaml matching the current active source file")

  yaml_entry
}

parse_targets_yaml <- function() {
  project_yaml <- yaml::read_yaml("./_targets.yaml")
  do.call(rbind,
    lapply(project_yaml, function(x) data.frame(script = x$script, store = x$store)))
}

cat_command <- function(command) cat(trimws(format(command)), "\n", sep = "")

#' @noRd
pipeline_template_data_tar_plan <- function() {

  glue::glue(
    "## pipeline\n",
    "## tar_plan supports drake-style targets and also tar_target()\n",
    "tar_plan(\n",
    "\n",
    "# target1 = function_to_make1(arg), ## drake style\n",
    "\n",
    "# tar_target(target2, function_to_make2(arg)) ## targets style\n",
    "\n",
    ")"
  )
  
}

#' @noRd
pipeline_template_data_tar_assign <- function() {

  glue::glue(
    "## pipeline\n",
    "## targets must end in a target object like tar_target()\n",
    "tar_assign({{\n",
    "\n",
    "# target1 = tar_target(function_to_make(arg))\n",
    "\n",
    "# target2 = arg |>\n",
    "#   function_to_make2() |>\n",
    "#   tar_target()\n",
    "\n",
    "}})"
  )
  
}

#' @noRd
pipeline_template_data_targets <- function() {

  glue::glue(
    "## pipeline\n",
    "list(\n",
    "\n",
    "# tar_target(target1, function_to_make1(arg),\n",
    "\n",
    "# tar_target(target2, function_to_make2(arg))\n",
    "\n",
    ")"
  )
  
}