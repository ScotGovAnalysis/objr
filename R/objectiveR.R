#' Core request function
#'
#' @param endpoint The endpoint to append to the API server address
#' @param method HTTP method to use; e.g. `GET`, `POST`, `PUT`.
#' Defaults to `GET`.
#' @param ... Named parameters to pass to header
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

  # Define header parameters
  params <- list(
    #...,
    accept = accept
  )

  # Build request
  request <-
    httr2::request("https://secure.objectiveconnect.co.uk/publicapi/1") |>
    httr2::req_url_path_append(endpoint) |>
    httr2::req_method(method) |>
    httr2::req_headers(!!!params) |>
    objectiveR_auth() |>
    httr2::req_user_agent(
      "objectiveR (https://github.com/DataScienceScotland/objectiveR)"
    )

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

  # Parse the response
  httr2::resp_body_json(response)

}
