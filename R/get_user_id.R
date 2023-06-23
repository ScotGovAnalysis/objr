#' Get user ID on current authenticated user
#'
#' @param use_proxy Logical; to indicate whether proxy required.
#'
#' @return A character value of the user ID
#'
#' @export

get_user_id <- function(use_proxy = FALSE) {

  request <-
    httr2::request("https://secure.objectiveconnect.co.uk/publicapi/1/me") |>
    httr2::req_url_query(includeActions = "true") |>
    objectiveR_auth() |>
    httr2::req_user_agent("objectiveR")

  if(use_proxy) {
    request <- httr2::req_proxy(request, get_proxy())
  }

  response <- httr2::req_perform(request)

  store_token(response, store_env = parent.frame())

  httr2::resp_body_json(response)$uuid

}
