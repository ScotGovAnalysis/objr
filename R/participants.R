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

  content <-
    httr2::resp_body_json(response)$content |>
    lapply(
      \(content) {
        data.frame(
          user_name = paste(content$user$givenName,
                            content$user$familyName),
          user_email = content$user$email,
          user_uuid = content$userUuid,
          bypass_2fa = content$bypassTwoStep,
          participant_uuid = content$uuid,
          workspace_name = content$workspace$name,
          workspace_uuid = content$workspace$uuid
        )
      }
    )

  Reduce(rbind, content)

}
