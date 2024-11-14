#' Get comments for workspaces of current user
#'
#' @details
#' More details on this endpoint are available in the
# nolint start: line_length_linter
#' \href{https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Comments/getComments}{API documentation}.
# nolint end
#'
#' @param created_after Date (and optionally time) to filter comments created
#' since this date/time. If a time is not supplied, all comments made on this
#' day will be included.
#' @param thread_uuid UUID of thread to filter by
#' @param mention_uuid UUID of user to filter comments where mentioned
#' @inheritParams objr
#' @inheritParams workspaces
#'
#' @return Data frame
#'
#' @examples
#' \dontrun{
#' comments()
#' }
#'
#' @export

comments <- function(created_after = NULL,
                     thread_uuid = NULL,
                     mention_uuid = NULL,
                     workgroup_uuid = NULL,
                     page = NULL,
                     size = NULL,
                     use_proxy = FALSE) {

  response <- objr(
    endpoint = "comments",
    url_query = list(createdAfter = convert_to_epoch(created_after),
                     threadUuid = thread_uuid,
                     mentionUuid = mention_uuid,
                     workgroupUuid = workgroup_uuid,
                     page = page,
                     size = size),
    use_proxy = use_proxy
  )

  dplyr::tibble(content = httr2::resp_body_json(response)$content) %>%
    tidyr::hoist(
      .data$content,
      type = "commentType",
      text = "commentText",
      name1 = c("creator", "givenName"),
      name2 = c("creator", "familyName"),
      created_time = "createdTime",
      thread_uuid = c("thread", "uuid"),
      workspace_name = c("workspace", "name"),
      workspace_uuid = c("workspace", "uuid"),
      .transform = list(created_time = convert_from_epoch)
    ) %>%
    dplyr::mutate(author = paste(.data$name1, .data$name2),
                  .after = "text") %>%
    dplyr::select(-c("name1", "name2", "content"))

}


#' Create a new thread
#'
#' @details
#' More details on this endpoint are available in the
# nolint start: line_length_linter
#' \href{https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Comments/createThread}{API documentation}.
# nolint end
#'
#' @param workspace_uuid UUID of workspace
#' @param text Character string to include in body of thread
#' @param mentioned_assets UUID(s) of asset(s) to mention
#' @param mentioned_users UUID(s) of user(s) to mention
#' @inheritParams objr
#'
#' @return API response (invisibly)
#'
#' @export

new_thread <- function(workspace_uuid,
                       text,
                       mentioned_assets = NULL,
                       mentioned_users = NULL,
                       use_proxy = FALSE) {

  response <- objr(
    endpoint = "threads",
    method = "POST",
    body = list(
      workspaceUuid = workspace_uuid,
      text = text,
      mentionedAssets = list(mentioned_assets),
      mentionedUsers = list(mentioned_users)
    ),
    use_proxy = use_proxy
  )

  if (httr2::resp_status(response) == 200) {
    cli::cli_alert_success("New thread created.")
  }

  invisible(response)

}


#' Create a new reply to a thread
#'
#' @details
#' More details on this endpoint are available in the
# nolint start: line_length_linter
#' \href{https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Comments/createReply}{API documentation}.
# nolint end
#'
#' @param thread_uuid UUID of thread to reply to
#' @inheritParams new_thread
#' @inheritParams objr
#'
#' @return API response (invisibly)
#'
#' @export

new_reply <- function(thread_uuid,
                      text,
                      mentioned_assets = NULL,
                      mentioned_users = NULL,
                      use_proxy = FALSE) {

  response <- objr(
    endpoint = "replies",
    method = "POST",
    body = list(
      threadUuid = thread_uuid,
      text = text,
      mentionedAssets = list(mentioned_assets),
      mentionedUsers = list(mentioned_users)
    ),
    use_proxy = use_proxy
  )

  if (httr2::resp_status(response) == 200) {
    cli::cli_alert_success("New reply created.")
  }

  invisible(response)

}
