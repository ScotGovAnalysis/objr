#' Helper function for validating input value
#'
#' @param value Value to verify
#' @param warn Logical. Indicates whether to produce warning if value is invalid
#'
#' @return Validated value
#'
#' @noRd

check_valid <- function(value, warn = FALSE) {

  # Works for single value only (not vectorised)
  if(length(value) > 1) {
    cli::cli_abort(
      c("x" = "Value must be length 1"),
      class = "objectiveR_value-invalid-length"
    )
  }

  valid <- !(is.null(value) || is.na(value) || !nchar(value) > 0)

  # If invalid and warn = TRUE, return warning
  if(!valid & warn) {
    cli::cli_warn(
      c("!" = "`value` must exist and be at least 1 character in length"),
      class = "objectiveR_value-invalid"
    )
  }

  # Return logical
  valid

}


#' Look for or ask for input value
#'
#' @description The function looks for the relevant value from environment
#' variables. If this doesn't exist and the session is interactive, the user
#' will be prompted to input a value. The value is then validated using
#' \code{check_valid()}.
#'
#' Expected environment variables for each \code{type} are as follows:
#' * usr: `OBJECTIVER_USR`
#' * pwd: `OBJECTIVER_PWD`
#' * proxy: `OBJECTIVER_PROXY`
#'
#' @param type One of 'usr' (username), 'pwd' (password), or 'proxy'.
#'
#' @return Validated value
#'
#' @noRd

input_value <- function(type = c("usr", "pwd", "proxy")) {

  type <- match.arg(type)

  envvar <- switch(
    type,
    "usr" = "OBJECTIVER_USR",
    "pwd" = "OBJECTIVER_PWD",
    "proxy" = "OBJECTIVER_PROXY"
  )

  # Get environment variable
  value <- Sys.getenv(envvar)

  # If environment variable doesn't exist or not valid
  if(!check_valid(value)) {

    # Error if session not interactive
    if(!rlang::is_interactive()) {
      cli::cli_abort(
        c("x" = "Environment variable (`{envvar}`) doesn't exist"),
        class = "objectiveR_invalid-envvar"
      )
    }

    # Set text for pop up prompt
    prompt <- switch(
      type,
      "usr" = "Enter email registered with Objective Connect:",
      "pwd" = "Enter Objective Connect password:",
      "proxy" = "Please enter proxy URL:"
    )

    # Give user 2 attempts to enter valid input
    for(i in 1:2) {
      value <- rstudioapi::askForPassword(prompt)
      if(check_valid(value)) break
    }

    if(!check_valid(value)) {
      cli::cli_abort(
        c("x" = "Failed to provide valid input")
      )
    }

  }

  # Return value
  value

}


#' Helper function to use curl::form_data when value is not null
#'
#' @param value Value to pass to curl::form_data
#'
#' @noRd

form_data_null <- function(value) {

  if(is.null(value)) {
    NULL
  } else {
    curl::form_data(value)
  }

}


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
