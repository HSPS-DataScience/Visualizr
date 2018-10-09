library(tidyverse)
library(trelliscopejs)
library(wordcloud)
library(HSPSUtils) # install_github("HSPS-DataScience/HSPSUtils")

knitr::opts_chunk$set(
  echo = F,
  message = F,
  warning = F,
  error = F,
  fig.height = 3,
  fig.width = 9.5,
  cache = F
)

data <- x # REPLACE X WITH YOUR DATA

## data table
DT::datatable(
  data %>%
    sample_n(1000),
    options = list(
      pageLength = 5,
      searching = T,
      scrollX = T
    )
  )

## Data Summary
data_summary <- data %>%
  select_if(is.numeric) %>%
  summarise_all(funs(
    numUnique = length(unique(.)),
    nas = sum(is.na(.)),
    max = max(., na.rm = T),
    min = min(., na.rm = T),
    mean = mean(., na.rm = T))) %>%
  gather() %>%
  separate(key, c("key", "stat"), sep = "_") %>%
  spread(key, value)
# generate datatable from summary
DT::datatable(
  data_summary,
  options = list(
    pageLength = 5,
    searching = T,
    scrollX = T
  )
)

# for (col_names in split_type_colnames_by_num(data)) {
  data %>%
    # select(col_names) %>%
    gather_group_by_count() %>%
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
# }

## wordcloud of character variables
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


## histogram of all numeric variables
data %>%
  select_if(is.numeric) %>%
  .select_non_id_columns() %>%
  gather() %>%
  filter(value >= 0) %>%
ggplot(aes(x = value)) +
  geom_histogram(binwidth = .25, bins = 30) +
  scale_y_continuous(labels = scales::comma) +
  scale_x_log10(breaks = c(0.1, 1, 10, 100, 1000, 10000),
                labels = c(0.1, 1, 10, 100, 1000, 10000)) +
  facet_wrap(~ key, scales = "free", ncol = 3) +
  theme_bw()


## time series
data %>%
  select_if(is.Date) %>%
  gather_group_by_count() %>%
  ungroup() %>%
ggplot(aes(x = value, y = Count)) +
  geom_line() +
  geom_smooth(method = "loess") +
  theme_bw()

# TODO: create function for error handling
# TODO: create functions for every r chunk
# TODO: for loop over each function using error handling function as wrapper
