#' Read in a tibble and generate summary statistics and visualizations
#'
#' @param data A tibble
#' @return RMarkdown file with finished visualizations and summary statistics
#' @import tidyverse trelliscopejs visualize_funcitons.R
#' @export
#' @examples
#' visualize(tbl)
visualize <- function(data) {
  # my_data <- read_csv("data/Accounts-20180423.csv") %>% as.tibble()

  data_sample <- data %>% sample_n(10000)

  func_list <- list(
    create_sampled_datatable,
    create_columns_summary_table,
    # create_bar_chart_levels_ts,
    create_wordcloud
  )

  # apply every function in func_list over the data to create all visualizations
  lapply(func_list, function(f) f(data_sample))
}
