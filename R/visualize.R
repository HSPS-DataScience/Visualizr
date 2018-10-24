#' Generate standalone RMarkdown file from a single command based off of a pre-defined template.
#'   This function is a wrapper around `RParser`, a Python library developed
#'   for parsing R scripts into Rmarkdown.
#'
#'   IMPORTANT: Make sure anaconda3 and rparser and installed before running visualize()
#'
#' @param new_filename path to new Rmd file being created
#' @import reticulate
#' @export
visualize <- function(new_filename = "./test.Rmd") {
  # rparser requires Python 3.6 or greater
  tryCatch(
    expr = use_python("/anaconda3/bin/python"),
    error = function(e) {
      message("Make sure Anaconda3 (/anaconda3/bin/python) \n\t and rparser (github.com/HSPS-DataScience/rparser) are installed")
    },
    warning = function(w) {
      message("Make sure Anaconda3 (/anaconda3/bin/python) \n\t and rparser (github.com/HSPS-DataScience/rparser) are installed")
    }
  )

  p$run_parser(new_filename = new_filename)
}

# global reference to parser (will be initialized in .onLoad)
p <- NULL

.onLoad <- function(libname, pkgname) {
  # use superassignment to update global reference to rparser
  p <<- reticulate::import("rparser", delay_load = TRUE)
}
