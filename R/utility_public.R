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
