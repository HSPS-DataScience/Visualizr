.is_categorical_col <- function(col) {
  is.character(col) | is.factor(col)
}

.split_categorical_cols <- function(data, n = 3) {
  data_colnames <- data %>%
    select_if(.is_categorical_col) %>%
    colnames()

  # without num_groups split() will return only n groups, not groups of n length
  num_groups <- length(data_colnames) %/% n
  split(data_colnames, cut(seq_along(data_colnames), num_groups, labels = FALSE))
}

.select_non_id_columns <- function(data) {
  data %>%
    select(-contains("id"))
}
