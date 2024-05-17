#' Generate random UUID
#'
#' @param seed Integer to set seed for random sampling. Default value is NULL.
#'
#' @return A single character value in the format of eight blocks of four
#' letters/integers separated by dashes.
#'
#' @noRd

random_uuid <- function(seed = NULL) {

  options <- c(letters, 0:9)

  # There should be equal probability of a letter or integer being sampled
  prob_weights <- c(rep(1/26, 26), rep(1/10, 10))

  set.seed(seed)

  replicate(8, paste0(sample(options, 4, replace = TRUE, prob = prob_weights),
                             collapse = "")) |>
  paste0(collapse = "-")

}
