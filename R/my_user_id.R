#' Get user ID for current authenticated user
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
