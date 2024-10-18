#' Helper function for validating input value
#'
#' @param value Value to verify
#' @param warn Logical. Indicates whether to produce warning if value is invalid
#'
#' @return Validated value
#'
#' @noRd

check_valid <- function(value,
                        warn = FALSE,
                        error_arg = rlang::caller_arg(value),
                        error_call = rlang::caller_env()) {

  # Works for single value only (not vectorised)
  if (length(value) > 1) {
    cli::cli_abort(
      "{.arg {error_arg}} must be length 1.",
      call = error_call,
      class = "objr_value-invalid-length"
    )
  }

  valid <- !(is.null(value) || is.na(value) || !nchar(value) > 0)

  # If invalid and warn = TRUE, return warning
  if (!valid && warn) {
    cli::cli_warn(
      c("!" = paste("{.arg {error_arg}} must exist and be at least",
                    "1 character in length.")),
      class = "objr_value-invalid"
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
#' * usr: `OBJR_USR`
#' * pwd: `OBJR_PWD`
#' * proxy: `OBJR_PROXY`
#'
#' @param type One of 'usr' (username), 'pwd' (password), or 'proxy'.
#'
#' @return Validated value
#'
#' @noRd

input_value <- function(type = c("usr", "pwd", "proxy"),
                        error_call = rlang::caller_env()) {

  type <- rlang::arg_match(type)

  envvar <- switch(
    type,
    "usr" = "OBJR_USR",
    "pwd" = "OBJR_PWD",
    "proxy" = "OBJR_PROXY"
  )

  # Get environment variable
  value <- Sys.getenv(envvar)

  # If environment variable doesn't exist or not valid
  if (!check_valid(value)) {

    # Error if session not interactive
    if (!rlang::is_interactive()) {
      cli::cli_abort(
        "Environment variable ({.envvar envvar}) doesn't exist.",
        call = error_call,
        class = "objr_invalid-envvar"
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
    for (i in 1:2) {
      value <- rstudioapi::askForPassword(prompt)
      if (check_valid(value)) break
    }

    if (!check_valid(value)) {
      cli::cli_abort("Failed to provide valid input.",
                     call = error_call)
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

  if (is.null(value)) {
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
  prob_weights <- c(rep(1 / 26, 26), rep(1 / 10, 10))

  set.seed(seed)

  replicate(8, paste0(sample(options, 4, replace = TRUE, prob = prob_weights),
                      collapse = "")) |>
    paste0(collapse = "-")

}


#' Check string is valid UUID format
#'
#' @param uuid Character string
#'
#' @return `uuid`, invisibly.
#'
#' @details See the [Getting Started vignette]
#'   (https://scotgovanalysis.github.io/objr/
#'   articles/objr.html#universally-unique-identifiers) for valid UUID format.
#'
#' @noRd

check_uuid <- function(uuid,
                       error_arg = rlang::caller_arg(uuid),
                       error_call = rlang::caller_env()) {

  if (!rlang::is_string(uuid)) {
    cli::cli_abort("{.arg {error_arg}} must be a string.",
                   call = error_call)
  }

  valid <- grepl(paste(rep("[A-Za-z0-9]{4}", 8), collapse = "-"),
                 uuid)

  if (!valid) {
    cli::cli_abort(c(
      "{.arg {error_arg}} must be valid UUID format.",
      "i" = paste0(
        "See the {.href [Getting Started vignette]",
        "(https://scotgovanalysis.github.io/objr/",
        "articles/objr.html#universally-unique-identifiers)} ",
        "for valid format."
      )
    ), call = error_call)
  }

  invisible(uuid)

}


#' Check value is a list
#'
#' @param x List.
#' @param allow_null Logical. If `allow_null = TRUE` (default), the function
#'   will also accept NULL values.
#'
#' @return `x`, invisibly.
#'
#' @noRd

check_list <- function(x,
                       allow_null = TRUE,
                       error_arg = rlang::caller_arg(x),
                       error_call = rlang::caller_env()) {

  if (!allow_null && is.null(x)) {
    cli::cli_abort("{.arg {error_arg}} must be supplied.",
                   call = error_call)
  }

  if (!is.null(x) && !rlang::is_list(x)) {
    cli::cli_abort("{.arg {error_arg}} must be a list.",
                   call = error_call)
  }

  invisible(x)

}


#' Convert date or datetime object to number of milliseconds from epoch
#'
#' @param date_time Date or datetime with "POSIXct" class.
#'
#' @details
#' * If only a date is supplied, a time of 00:00:00 will be added.
#' * If NULL is supplied, NULL is returned.
#' * If an invalid value is supplied (not date, datetime or NULL), an error will
#' be produced.
#'
#' @return Integer
#'
#' @examples
#' convert_to_epoch(as.POSIXct("2024-01-01 09:00:00"))
#'
#' @noRd

convert_to_epoch <- function(date_time,
                             error_arg = rlang::caller_arg(date_time),
                             error_call = rlang::caller_env()) {

  if (is.null(date_time)) {
    return(NULL)
  }

  # Check correct class if supplied
  if (!"POSIXct" %in% class(date_time)) {
    cli::cli_abort(
      "{.arg {error_arg}} must be of POSIXct class.",
      call = error_call
    )
  }

  as.integer(date_time) * 1000

}


#' Convert number of milliseconds to epoch to date or datetime object
#'
#' @param x Numeric.
#'
#' @details If NULL is supplied, NULL is returned.
#'
#' @return Date (POSIXct class).
#'
#' @examples
#' convert_from_epoch(1726095601000)
#'
#' @noRd

convert_from_epoch <- function(x,
                               error_arg = rlang::caller_arg(x),
                               error_call = rlang::caller_env()) {

  if (is.null(x)) {
    return(NULL)
  }

  # Check correct class if supplied
  if (!inherits(x, "numeric")) {
    cli::cli_abort(
      "{.arg {error_arg}} must be of numeric class.",
      call = error_call
    )
  }

  as.POSIXct(x / 1000, origin = "1970-01-01")

}
