#' Read in any data source and ensure it is a tibble
#' PRIVATE FUNCTION
#'
#' @param filename the name and path to the file being ingested into Visualizr
#' @return A tibble of the data
#' @seealso visualize
#' @import readxl stringr magrittr
#' @export
#' @examples
#' visualize <- function(filename = "my_file.txt") {
#'   data <- .read_data(filename)
#' }
.read_data <- function(filename) {
  if (str_detect(filename, ".*\\.csv")) {
    data <- read_csv(filename) %>% as.tibble()
  } else if (str_detect(filename, ".*\\.xlsx")) {
    data <- read_excel(filename) %>% as.tibble()
  }
}
