#' Authenticate HTTP request
#'
#' @description This sets the authorisation header of an HTTP request. If a
#' token variable exists in global environment, this is used, otherwise,
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
#'   httr2::request("http://example.com") |>
#'   objectiveR_auth(usr = "ex-usr", pwd = "ex-pwd")
#' req
#' req |> httr2::req_dry_run()
#'
#' token <- "test"
#' req <- httr2::request("http://example.com") |> objectiveR_auth()
#' req
#' req |> httr2::req_dry_run()
#'
#' @export

objectiveR_auth <- function(req, usr = NULL, pwd = NULL) {

  # Check request is correct type
  if(!inherits(req, "httr2_request")) {
    cli::cli_abort(c(
      "x" = "{.var req} must be an HTTP2 request object"
    ))
  }

  session_token <-
    if(exists("token", where = parent.frame())) {
      get("token", pos = parent.frame())
    } else {
      NULL
    }

  if(!is.null(session_token)) {

    httr2::req_headers(req, Authorization = session_token)

  } else {

    usr <- valid_input("usr", usr)
    pwd <- valid_input("pwd", pwd)

    httr2::req_auth_basic(req, usr, pwd)

  }

}
