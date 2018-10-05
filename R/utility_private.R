#' Checks column data type for either character or factor
#'
#' @param col a column of data (vector)
#' @return Boolean
#' @examples
#' data %>%
#'   select_if(.is_categorical_col)
.is_categorical_col <- function(col) {
  is.character(col) | is.factor(col)
}

#' Splits categorical columns into groups of 3 (by default)
#'
#' @param data a tibble
#' @return a vector of grouped categorical column names
.split_categorical_cols <- function(data, n = 3) {
  data_colnames <- data %>%
    select_if(.is_categorical_col) %>%
    colnames()

  # without num_groups split() will return only n groups, not groups of n length
  num_groups <- length(data_colnames) %/% n
  split(data_colnames, cut(seq_along(data_colnames), num_groups, labels = FALSE))
}

#' In some cases, it is important to exclude ID variables from datasets. .select_non_id_columns()
#'   takes a tibble and selects only column names which do not mention as being IDs.
#'
#' @param data a tibble
#' @return a tibble
.select_non_id_columns <- function(data) {
  data %>%
    select(-contains("id"))
}



