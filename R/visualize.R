#' Generate Rmarkdown report and Rmarkdown standalone file from a single command.
#'   This function is a wrapper around `RParser`, a Python library developed
#'   for parsing R scripts into Rmarkdown.
#'
#' @param new_filename path to new Rmd file being created
#' @import reticulate
#' @export
visualize <- function(new_filename = "./test.Rmd") {
  parser <- p$run_parser(new_filename = new_filename)

  # knit newly created Rmd file
  rmarkdown::render(new_filename)
}

# global reference to parser (will be initialized in .onLoad)
p <- NULL

.onLoad <- function(libname, pkgname) {
  # use superassignment to update global reference to rparser
  p <<- reticulate::import("rparser", delay_load = TRUE)
}
