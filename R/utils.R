#' Helper function for getting valid input value
#'
#' @param type One of 'usr' (username), 'pwd' (password), or 'proxy'.
#' @param value Value to verify. If NULL, user will be prompted to enter.
#'
#' @return Validated value

valid_input <- function(type = c("usr", "pwd", "proxy"), value = NULL) {

  type <- match.arg(type)

  # If not interactive, value must be supplied
  if(!rlang::is_interactive() & is.null(value)) {
    cli::cli_abort(
      c("x" = paste0("{.var ", type, "} value must be supplied.")),
      class = "objectiveR_value-not-supplied"
    )
  }

  # Set text for pop up prompt, if required
  prompt <- switch(
    type,
    "usr" = "Enter email registered with Objective Connect:",
    "pwd" = "Enter Objective Connect password:",
    "proxy" = "Please enter proxy URL:"
  )

  if(rlang::is_interactive() & is.null(value)) {
    value <- rstudioapi::askForPassword(prompt)
  }

  # Check value is not null and at least 1 character long
  if(is.null(value) || !nchar(value) > 0) {
    cli::cli_abort(
      c("x" = paste0("{.var ", type, "} value must not be null and must be ",
                     "more than 0 characters in length.")),
      class = "objectiveR_value-invalid"
    )
  }

  value

}
