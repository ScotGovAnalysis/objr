#' Get user ID for current authenticated user
#'
#' @inheritParams objectiveR
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

  response <- objectiveR("me", use_proxy = use_proxy)

  response$uuid

}
