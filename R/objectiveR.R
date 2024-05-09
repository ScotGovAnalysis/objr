#' Core request function
#'
#' @param endpoint The endpoint to append to the API server address
#' @param url_path A list of values to be added to the request URL path.
#' Values will be separated with `/`.
#' @param url_query A list of named values to define query parameters
#' @param method HTTP method to use; e.g. `GET`, `POST`, `PUT`.
#' Defaults to `GET`.
#' @param body A list of named values to be passed to the request body
#' @param path Optional file path to save body of request (mainly used when
#' downloading files)
#' @param accept Accept header. Defaults to 'application/json'.
#' @param content_type Content-Type header. Defaults to 'application/json'.
#' @param use_proxy Logical to indicate whether to use proxy
#'
#' @return An httr2 [httr2::response()][response]
#'
#' @export

objectiveR <- function(endpoint,
                       url_path = NULL,
                       url_query = NULL,
                       method = "GET",
                       body = NULL,
                       path = NULL,
                       accept = "application/json",
                       content_type = "application/json",
                       use_proxy = FALSE) {

  # Check lists supplied (better way to do this)
  stopifnot(
    "`url_path` must be a list" = class(url_path) %in% c("NULL", "list")
  )
  stopifnot(
    "`url_query` must be a list" = class(url_query) %in% c("NULL", "list")
  )
  stopifnot(
    "`body` must be a list" = class(body) %in% c("NULL", "list")
  )

  # Build request
  request <-
    httr2::request("https://secure.objectiveconnect.co.uk/publicapi/1") |>
    httr2::req_url_path_append(endpoint) |>
    httr2::req_method(method) |>
    httr2::req_headers(accept = accept,
                       `content-type` = content_type) |>
    objectiveR_auth() |>
    httr2::req_user_agent(
      "objectiveR (https://scotgovanalysis.github.io/objectiveR/)"
    ) |>
    httr2::req_error(body = error)

  # Modify the URL path
  request <- rlang::inject(
    httr2::req_url_path_append(request, !!!url_path)
  )

  # Add URL query parameters
  request <- rlang::inject(
    httr2::req_url_query(request, !!!url_query)
  )

  # Add request body
  if(!is.null(content_type) && !is.null(body)) {
    if(content_type == "multipart/form-data") {
      request <- rlang::inject(
        httr2::req_body_multipart(request, !!!body)
      )
    }
    if(content_type == "application/json") {
      request <- httr2::req_body_json(request, body)
    }
  }

  # Add proxy details
  if(use_proxy) {
    request <- httr2::req_proxy(request, input_value("proxy"))
  }

  # Perform request
  response <- httr2::req_perform(request, path = path)

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
#'
#' @noRd

error <- function(response) {

  switch(
    as.character(httr2::resp_status(response)),
    "401" = "Authorisation failed. Check username / password / token.",
    "403" = paste("Operation not permitted.")
  )

}
