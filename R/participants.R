#' Get data frame of workspace participants
#'
#' @param workspace_uuid UUID of workspace
#' @inheritParams objr
#'
#' @return Data frame
#'
#' @export

participants <- function(workspace_uuid, use_proxy = FALSE) {

  response <- objr(
    endpoint = "participants",
    url_query = list(workspaceUuid = workspace_uuid),
    use_proxy = use_proxy
  )

  dplyr::tibble(content = httr2::resp_body_json(response)$content) %>%
    tidyr::hoist(
      .data$content,
      name1 = c("user", "givenName"),
      name2 = c("user", "familyName"),
      user_email = c("user", "email"),
      user_uuid = "userUuid",
      bypass_2fa = "bypassTwoStep",
      participant_uuid = "uuid",
      workspace_name = c("workspace", "name"),
      workspace_uuid = c("workspace", "uuid")
    ) %>%
    dplyr::mutate(user_name = paste(.data$name1, .data$name2),
                  .before = 0) %>%
    dplyr::select(-c("name1", "name2", "content"))

}
