#' Authenticate HTTP request
#'
#' @description This sets the authorisation header of an HTTP request. If a
#' token variable exists in global environment, this is used, otherwise,
#' the user is prompted to enter an authenticating username and password.
#'
#' @param req An [httr2 request](https://httr2.r-lib.org/reference/request.html)
#'
#' @return A modified [httr2 request](https://httr2.r-lib.org/reference/request.html)
#'
#' @examples
#' \dontrun{
#' httr2::request("http://example.com") |>
#'   objectiveR_auth()
#' }
#'
#' token <- "test"
#' httr2::request("http://example.com") |> objectiveR_auth()
#'
#' @export

objectiveR_auth <- function(req) {

  # Check request is correct type
  if(!inherits(req, "httr2_request")) {
    cli::cli_abort(c(
      "x" = "{.var req} must be an HTTP2 request object"
    ))
  }

  if(exists("token", where = parent.frame())) {

    httr2::req_headers(
      req,
      Authorization = get("token", pos = parent.frame())
    )

  } else {

    httr2::req_auth_basic(
      req,
      input_value("usr"),
      input_value("pwd")
    )

  }

}
