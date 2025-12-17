#' Get mobile authenticator details of the current authenticated user
#'
#' @details
#' More information on mobile authentication can be found in
#' `vignette("authentication")`.
#'
#' More details on this endpoint are available in the
# nolint start: line_length_linter
#' \href{https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/MobileAuth/getMobileAuthDetails}{API documentation}.
# nolint end
#'
#' @inheritParams objr
#'
#' @return A list object containing 2 logical values:
#' * `mobileAuthLogin`: Has the user enabled login via Mobile Authenticator?
#' * `mobileAuthRegistered`: Has the user registered a Mobile Authenticator?
#'
#' @export

mobile_auth_status <- function(use_proxy = FALSE) {

  response <- objr::objr("mobileauth", use_proxy = use_proxy)

  httr2::resp_body_json(response)

}


#' Login using mobile authenticator
#'
#' @details
#' Mobile authenticator login attempts are limited to a maximum of 5 failures
#' within a 5-minute interval. After 5 failed attempts, your Objective Connect
#' account will be locked. To regain access, wait for 5 mins and then try
#' logging in again.
#'
#' More information on mobile authentication can be found in
#' `vignette("authentication")`.
#'
#' More details on this endpoint are available in the
# nolint start: line_length_linter
#' \href{https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/MobileAuth/login}{API documentation}.
# nolint end
#'
#' @param code Character string. Time-based one time-password from mobile
#' authenticator. If not supplied, a pop-up window will prompt the user to
#' enter.
#' @inheritParams objr
#'
#' @return API response (invisibly)
#'
#' @export

mobile_auth_login <- function(code = NULL, use_proxy = FALSE) {

  if (!is.null(code)) {

    if (!rlang::is_character(code)) {
      cli::cli_abort(
        "{.arg code} must be a character type, not {typeof(code)}."
      )
    }
    if (!check_valid(code)) {
      cli::cli_abort("Failed to provide valid input.")
    }

    # If code isn't provided and session is interactive, prompt user to enter
  } else if (rlang::is_interactive()) {
    code <- input_value("mobileauth")
  } else {
    cli::cli_abort("{.arg code} must be provided.")
  }

  response <- objr::objr(
    endpoint = "mobileauth",
    url_path = list("login"),
    method = "PUT",
    body = list(totp = code),
    use_proxy = use_proxy
  )

  if (httr2::resp_status(response) == 204) {
    cli::cli_alert_success(
      "Successfully logged in via Mobile Authenticator."
    )
  }

  invisible(response)

}
