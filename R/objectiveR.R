#' Core request function
#'
#' @param endpoint The endpoint to append to the API server address
#' @param method HTTP method to use; e.g. `GET`, `POST`, `PUT`.
#' Defaults to `GET`.
#' @param ... Named parameters to pass to request body
#' @param accept Accept header
#' @param use_proxy Logical to indicate whether to use proxy
#'
#' @return An httr2 [httr2::response()][response]
#'
#' @export

objectiveR <- function(endpoint,
                       method = "GET",
                       ...,
                       accept = "application/json",
                       use_proxy = FALSE) {

  # Define body parameters
  params <- list(...)

  # Build request
  request <-
    httr2::request("https://secure.objectiveconnect.co.uk/publicapi/1") |>
    httr2::req_url_path_append(endpoint) |>
    httr2::req_method(method) |>
    httr2::req_headers(accept = accept) |>
    httr2::req_body_json(params) |>
    objectiveR_auth() |>
    httr2::req_user_agent(
      "objectiveR (https://scotgovanalysis.github.io/objectiveR/)"
    ) |>
    httr2::req_error(body = error)

  # Add proxy details
  if(use_proxy) {
    request <- httr2::req_proxy(request, input_value("proxy"))
  }

  # Perform request
  response <- httr2::req_perform(request)

  # Check status of response
  httr2::resp_check_status(response)

  # Store token for future requests
  store_token(response)

  # Return response
  response

}


#' Translate error code into helpful message
#'
#' @param response An httr2 [httr2::response()][response]
#'
#' @return A character vector to include in error message.

error <- function(response) {
  code <- httr2::resp_status(response)
  if(code == 401) {
    "Authorisation failed. Check username / password / token."
  } else {
    NULL
  }
}
