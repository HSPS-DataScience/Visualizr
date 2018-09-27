#' Create table out of 1000 samples of data from tibble
#'
#' @param data A tibble
#' @return datatable
#' @examples
#' visualize(tbl)
create_sampled_datatable <- function(data) {
  DT::datatable(
    data %>%
      sample_n(1000),
      options = list(
        pageLength = 5,
        searching = T,
        scrollX = T
      )
    )
}

#' Generate summary table for each column in tibble
#'
#' @param data A tibble
#' @return datatable
#' @import dplyr
#' @export
#' @examples
#' visualize(tbl)
create_columns_summary_table <- function(data) {
  data_summary <- data %>%
    summarise_all( funs(
      numUnique = length(unique(.)),
      nas = sum(is.na(.)),
      max = max(., na.rm = T),
      min = min(., na.rm = T),
      mean = mean(., na.rm = T))) %>%
    gather() %>%
    separate(key, c("key", "stat"), sep = "_") %>%
    spread(key, value)

  DT::datatable(
    data_summary,
    options = list(
      pageLength = 5,
      searching = T,
      scrollX = T
    )
  )
}

#' Generate bar charts for all categorical variables
#'
#' @param data A tibble
#' @return trelliscope interactive visualization
#' @import drplyr ggplot2 utility_functions.R
#' @export
#' @examples
#' visualize(tbl)
create_bar_chart_levels_ts <- function(data) {
  # plot basic bar chart of the levels of each factor by groups of 3
  for (col_names in .split_categorical_cols(data)) {
    data %>%
      select(col_names) %>%
      gather() %>%
      group_by(key, value) %>%
      mutate(Count = length(value)) %>%
      slice(1) %>%
      ungroup() %>%
    ggplot(aes(x = value, y = Count)) +
      geom_bar(stat = "identity", alpha = 0.5) +
      geom_text(aes(label = scales::comma(Count))) +
      theme_bw() +
      coord_flip() +
      labs(x = "", y = "") +
      facet_trelliscope(~ key,
                        scales = "free",
                        self_contained = T,
                        width = 600,
                        name = "categoricalVariables",
                        group = "vars",
                        desc = "All Variables of Type Character or Factor")
  }
}

#' Generate wordcloud from all character data type columns
#'
#' @param data A tibble
#' @return wordcloud
#' @import dplyr wordcloud
#' @export
#' @examples
#' visualize(tbl)
create_wordcloud <- function(data) {
  data(stop_words)
  # make text string

  char_colnames <- data %>%
    select_if(is.character) %>%
    .select_non_id_columns() %>%
    pull()

  data_frame(line = 1:length(text), text = text) %>%
    unnest_tokens(word, text) %>%
    anti_join(stop_words) %>%
    count(word) %>%
    with(wordcloud(word, n, max.words = 100, rot.per = 0))
}

#' Generate wordcloud from all character data type columns
#'
#' @param data A tibble
#' @return wordcloud
#' @import dplyr wordcloud
#' @export
#' @examples
#' visualize(tbl)
create_hist_from_numeric <- function(data) {
  x2 <- data %>%
    select_if(is.numeric) %>%
    .select_non_id_columns() %>%
    gather() %>%
    filter(value > 0)

  ggplot(data = x2,
         aes(x = value)) +
    geom_histogram() +
    scale_y_continuous(labels = scales::comma) +
    scale_x_log10(breaks = c(0.1, 1, 10, 100, 1000, 10000),
                  labels = c(0.1, 1, 10, 100, 1000, 10000)) +
    facet_wrap(~ key, scales = "free", ncol = 2) +
    theme_bw()
}
