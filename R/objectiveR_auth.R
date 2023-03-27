#' Helper function for getting valid credentials
#'
#' @param type Either 'usr' (username) or 'pwd' (password).
#' @param value Credential value to verify.
#'
#' @return

credential_helper <- function(type = c("usr", "pwd"), value = NULL) {

  type <- match.arg(type)

  # If not interactive, value must be supplied
  if(!rlang::is_interactive() & is.null(value)) {
    cli::cli_abort(c(
      "x" = paste0("{.var ", type, "} must be supplied.")
    ))
  }

  # If interactive and value not supplied, prompt user to enter
  prompt <- if(type == "usr") {
    "Enter email registered with Objective Connect:"
  } else {
    "Enter Objective Connect password:"
  }

  if(rlang::is_interactive() & is.null(value)) {
    value <- rstudioapi::askForPassword(prompt)
  }

  # Check value is not null
  if(is.null(value)) {
    cli::cli_abort(c("x" = paste0("{.var ", type, "} must not be null")))
  }

  # Check value is at least 1 character long
  if(!nchar(value) > 0) {
    cli::cli_abort(c(
      "x" = paste0("{.var ", type, "} must be more than 0 characters")
    ))
  }

  value

}


#' Authenticate HTTP request
#'
#' @description This sets the authorisation header of an HTTP request. If a
#' bearer variable exists in global environment, this is used, otherwise,
#' the user is prompted to enter an authenticating username and password.
#'
#' @param req An httr2 [httr2::request()][request]
#' @param usr,pwd Username and password for basic authentication.
#' These arguments are required when using basic authentication in a
#' non-interactive environment. If working interactively, these
#' can be ignored and RStudio will prompt you to enter.
#'
#' @return A modified httr2 [httr2::request()][request]
#'
#' @examples
#' req <-
#'   httr2::request("http://example.com") %>%
#'   objectiveR_auth(usr = "ex-usr", pwd = "ex-pwd")
#' req
#' req %>% httr2::req_dry_run()
#'
#' bearer <- "test-bearer"
#' req <- httr2::request("http://example.com") %>% objectiveR_auth()
#' req
#' req %>% httr2::req_dry_run()
#'
#' @export

objectiveR_auth <- function(req, usr = NULL, pwd = NULL) {

  # Check request is correct type
  if(!inherits(req, "httr2_request")) {
    cli::cli_abort(c(
      "x" = "{.var req} must be an HTTP2 request object"
    ))
  }

  bearer_token <-
    if(exists("bearer", where = .GlobalEnv)) {
      get("bearer", pos = .GlobalEnv)
    } else {
      NULL
    }

  if(!is.null(bearer_token)) {

    httr2::req_auth_bearer_token(req, bearer_token)

  } else {

    usr <- credential_helper("usr", usr)
    pwd <- credential_helper("pwd", pwd)

    httr2::req_auth_basic(req, usr, pwd)

  }

}

