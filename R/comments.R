#' Get comments for workspaces of current user
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

  content <-
    httr2::resp_body_json(response)$content |>
    lapply(
      \(content) {
        data.frame(
          type = content$commentType,
          text = content$commentText,
          author = paste(content$creator$givenName,
                         content$creator$familyName),
          created_time = as.POSIXct(content$createdTime / 1000,
                                    origin = "1970-01-01"),
          thread_uuid = content$thread$uuid,
          workspace_name = content$workspace$name,
          workspace_uuid = content$workspace$uuid
        )
      }
    )

  Reduce(dplyr::bind_rows, content)

}


#' Create a new thread
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

  if(httr2::resp_status(response) == 200) {
    cli::cli_alert_success("New thread created.")
  }

  invisible(response)

}


#' Create a new reply to a thread
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

  if(httr2::resp_status(response) == 200) {
    cli::cli_alert_success("New reply created.")
  }

  invisible(response)

}


#' Convert date or datetime object to number of milliseconds from epoch
#'
#' @param date_time Date or datetime.
#'
#' @details
#' * If only a date is supplied, a time of 00:00:01 will be added.
#' * If NULL is supplied, NULL is returned.
#' * If an invalid value is supplied (not date, datetime or NULL), an error will
#' be produced.
#'
#' @return Integer
#'
#' @examples
#' convert_to_epoch(as.POSIXct("2024-01-01 09:00:00"))
#'
#' @noRd

convert_to_epoch <- function(date_time,
                             error_arg = rlang::caller_arg(date_time),
                             error_call = rlang::caller_env()) {

  if (is.null(date_time)) {
    return(NULL)
  }

  # Check correct class if supplied
  if (any(!class(date_time) %in% c("Date", "POSIXct", "POSIXt"))) {
    cli::cli_abort("{.arg {error_arg}} must be of Date or POSIXct class.",
                   call = error_call
    )
  }

  # Add time if only date supplied
  if (any(class(date_time) == "Date")) {
    date_time <- as.POSIXct(paste(date_time, "00:00:01"))
  }

  as.integer(date_time) * 1000

}
