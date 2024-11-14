#' Get user ID for current authenticated user
#'
#' @details
#' More details on this endpoint are available in the
# nolint start: line_length_linter
#' \href{https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Users/getCurrentUser}{API documentation}.
# nolint end
#'
#' @inheritParams objr
#'
#' @return A character value of the authenticated user's ID
#'
#' @examples
#' \dontrun{
#' my_user_id()
#' }
#'
#' @export

my_user_id <- function(use_proxy = FALSE) {

  response <- objr("me", use_proxy = use_proxy)

  httr2::resp_body_json(response)$uuid

}
