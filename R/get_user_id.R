#' Get information on current authenticated user
#'
#' @return HTTP response
#' @export

get_user_id <- function() {

  response <-
    httr2::request("https://secure.objectiveconnect.co.uk/publicapi/1/me") %>%
    httr2::req_url_query(includeActions = "true") %>%
    objectiveR_auth() %>%
    httr2::req_user_agent("objectiveR") %>%
    httr2::req_perform()

  store_bearer(response)

  response

}
