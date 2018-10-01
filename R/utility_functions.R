.is_categorical_col <- function(col) {
  is.character(col) | is.factor(col)
}

.is_date_time_col <- function(col) {

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

#' Gather, group_by the generated key and value, count, then slice
#'   to create a frequency table of the tibble. Functions with multiple
#'   variables.
#'
#' @param data A tibble
#' @return A tibble
#' @import dplyr
#' @export
#' @example
#' mtcars %>%
#'   select(am) %>%
#'   .gather_group_by_count()
#'
#'   key   value Count
#'   <chr> <dbl> <int>
#' 1 am        0    19
#' 2 am        1    13
.gather_group_by_count <- function(data) {
  data %>%
    gather() %>%
    group_by(key, value) %>%
    mutate(Count = length(value)) %>%
    slice(1) # slices the first group of data, giving us the final table
}
