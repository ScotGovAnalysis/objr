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

objr <- function(endpoint,
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
    objr_auth() |>
    httr2::req_user_agent(
      "objr (https://scotgovanalysis.github.io/objr/)"
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

  check_pages(response)

  # Return response
  response

}


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
#'   objr_auth()
#' }
#'
#' token <- "test"
#' httr2::request("http://example.com") |> objr_auth()
#'
#' @export

objr_auth <- function(req) {

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


#' Store session token from API response
#'
#' @param response An httr2 response object; must contain an 'Authorization'
#' header.
#' @param store_env The environment to bind the token to.
#'
#' @return Returns the token invisibly. This function is primarily used
#' for its side effect - an environment variable is created called "token".
#'
#' @noRd

store_token <- function(response, store_env = globalenv()) {

  # Check response is in expected format
  if(!inherits(response, "httr2_response")) {
    cli::cli_abort(c(
      "x" = "{.var response} must be an HTTP response object"
    ))
  }

  # Check Authorization header exists
  if(!httr2::resp_header_exists(response, "Authorization")) {
    cli::cli_abort(c(
      "x" = "{.var response} must have Authorization header"
    ))
  }

  token <- httr2::resp_header(response, "Authorization")

  if(!exists("token", where = store_env)) {
    rlang::env_poke(env = store_env, nm = "token", value = token)
  }

  return(invisible(token))

}


#' Translate error code into helpful message
#'
#' @param response An httr2 [httr2::response()][response]
#'
#' @return A character vector to include in error message.
#'
#' @noRd

error <- function(response) {
  status <- httr2::resp_status(response)

  if (status == 401) {
    c(
      "Authorisation failed. Check username / password / token.",
      paste(
        "You might have an expired token in your R environment.",
        "Remove it with `rm(token)`."
      )
    )
  } else {
    if (status == 403) {
      desc <- httr2::resp_body_json(response)$description

      c(
        desc,
        if (grepl("REQUIRES_2FA", desc)) {
          "See https://scotgovanalysis.github.io/objr/articles/two-factor.html"
        }
      )
    }
  }
}


check_pages <- function(response, call = rlang::caller_env()) {

  metadata <- if(httr2::resp_has_body(response)) {
    try(httr2::resp_body_json(response)$metadata)
  }

  if(!is.null(metadata)) {

    if(any(!c("totalPages", "page") %in%  names(metadata))) {
      cli::cli_abort(
        "{.code totalPages} and {.code page} must exist in {.arg metadata}.",
        class = "metadata-values-dont-exist"
      )
    }

    if(metadata$page > metadata$totalPages) {
      cli::cli_abort(
        paste(
          "Page requested doesn't exist.",
          "Pages available: {0:(metadata$totalPages-1)}."
        ),
        class = "page-doesnt-exist",
        call = call
      )
    }

    more_available <- metadata$totalPages > 1

    if(more_available) {

      cli::cli_warn(paste(
        "More results are available.",
        "Returning page {metadata$page + 1} of {metadata$totalPages}."
      ))

      cli::cli_li(c(
        paste(
          "Use the {.arg size} argument to control the number of results",
          "returned per page."
        ),
        paste(
          "Use the {.arg page} argument to determine which page of results",
          "is returned."
        )
      ))

    }

  }

}

