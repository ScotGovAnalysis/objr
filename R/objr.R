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

  check_list(url_path)
  check_list(url_query)
  check_list(body)

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

  # Return response
  response |>
    httr2::resp_check_status() |>
    store_token() |>
    check_pages()

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
#' @noRd

objr_auth <- function(req,
                      error_arg = rlang::caller_arg(req),
                      error_call = rlang::caller_env()) {

  # Check request is correct type
  if(!inherits(req, "httr2_request")) {
    cli::cli_abort("{.arg {error_arg}} must be an HTTP2 request object.",
                   call = error_call)
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

store_token <- function(response,
                        store_env = globalenv(),
                        error_arg = rlang::caller_arg(response),
                        error_call = rlang::caller_env()) {

  # Check response is in expected format
  if(!inherits(response, "httr2_response")) {
    cli::cli_abort("{.arg {error_arg}} must be an HTTP response object.",
                   call = error_call)
  }

  # Check Authorization header exists
  if(!httr2::resp_header_exists(response, "Authorization")) {
    cli::cli_abort("{.arg {error_arg}} must have Authorization header.",
                   call = error_call)
  }

  token <- httr2::resp_header(response, "Authorization")

  if(!exists("token", where = store_env)) {
    rlang::env_poke(env = store_env, nm = "token", value = token)
  }

  invisible(response)

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

  desc <- tryCatch(httr2::resp_body_json(response)$description,
                   error = function(e) NULL)

  extra <- NULL

  if (status == 401) {
    extra <- c(
      "Authorisation failed. Check username / password / token.",
      paste(
        "You might have an expired token in your R environment.",
        "Remove it with `rm(token)`."
      )
    )
  }

  if (status == 403 && grepl("REQUIRES_2FA", desc)) {
    extra <-
      "See https://scotgovanalysis.github.io/objr/articles/two-factor.html"
  }

  c(desc, extra)

}


#' Check number of pages returned in response
#'
#' @param response An httr2 [httr2::response()][response]
#' @param call Passed to `cli::cli_abort()`.
#'
#' @return Returns `response` invisibly. This function is primarily used for
#' printing useful error/warning/message(s).
#'
#' @noRd

check_pages <- function(response,
                        error_arg = rlang::caller_arg(response),
                        error_call = rlang::caller_env()) {

  metadata <- tryCatch(httr2::resp_body_json(response)$metadata,
                       error = function(e) NULL)

  if(!is.null(metadata)) {

    if(any(!c("totalPages", "page") %in%  names(metadata))) {
      cli::cli_abort(
        paste("{.code totalPages} and {.code page} must exist",
              "in {.arg metadata} element of response body."),
        call = error_call,
        class = "metadata-values-dont-exist"
      )
    }

    # metadata$page starts counting from 0
    # metadata$totalPages starts counting from 1
    pages_available <- 0:(metadata$totalPages - 1)

    if (!metadata$page %in% pages_available) {
      cli::cli_abort(c(
        "Page {metadata$page} doesn't exist.",
        "i" = "Pages available: {pages_available}.",
        "i" = "Note that the first page available is page 0 (not page 1).",
        "i" = "Use {.arg page} to control what page is returned.",
        "i" = paste("use {.arg size} to control the number of elements",
                    "on each page.")),
        call = error_call,
        class = "page-doesnt-exist"
      )
    }

    more_available <- metadata$totalPages > 1

    if(more_available) {

      cli::cli_warn(c(
        "i" = "Returning page {metadata$page}. More pages are available.",
        "i" = "Pages available: {pages_available}.",
        "i" = "Note that the first page available is page 0 (not page 1).",
        "i" = "Use {.arg page} to control what page is returned.",
        "i" = paste("use {.arg size} to control the number of elements",
                    "on each page.")
      ))

    }

  }

  invisible(response)

}
