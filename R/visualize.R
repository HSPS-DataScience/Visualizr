#' Generate Rmarkdown report and Rmarkdown standalone file from a single command
#'
#' @param rscript_path path to the rscript for Rmd conversion and redending
#' @param new_filename path to new Rmd file being created
#' @import HSPSUtils reticulate
#' @export
visualize <- function(rscript_path = "R/visualize_functions.R", new_filename = "test.Rmd") {
  parser <- p$parser$Parser(rscript_path, new_filename)

  # create new Rmd file
  parser$write_to_new_rmd()

  # knit newly created Rmd file
  # rmarkdown::render(new_filename)
}

# global reference to parser (will be initialized in .onLoad)
parser <- NULL

.onLoad <- function(libname, pkgname) {
  # use superassignment to update global reference to scipy
  p <<- reticulate::import("rparser", delay_load = TRUE)
}
