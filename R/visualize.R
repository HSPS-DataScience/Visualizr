#' Generate Rmarkdown report and Rmarkdown standalone file from a single command
#'
#' @param rscript_path path to the rscript for Rmd conversion and redending
#' @param new_filename path to new Rmd file being created
#' @import HSPSUtils reticulate
#' @export
visualize <- function(rscript_path = "R/visualize_functions.R", new_filename = "test.Rmd") {
  reticulate::source_python("Python/parser.py")
  parser <- Parser(rscript_path, new_filename)

  # create new Rmd file
  parser$write_to_new_rmd()

  # knit newly created Rmd file
  # rmarkdown::render(new_filename)
}

