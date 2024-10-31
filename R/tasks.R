#' Get tasks in workspaces
#'
#' @param workspace_uuid UUID of workspace to filter on
#' @param workspace_owner_uuid UUID of workspace owner of workspaces to filter
#' on
#' @param asset_uuid UUID of asset to filter on
#' @param assigned_to_me Logical; If `TRUE`, will filter on tasks assigned to
#' authenticated user
#' @param created_by_me Logical; If `TRUE`, will filter on tasks created by
#' authenticated user
#' @param status One of "all", "open", "cancelled", "complete"
#' @param workgroup_uuid UUID of workgroup to filter on
#' @inheritParams objr
#' @inheritParams workspaces
#'
#' @return Tibble
#'
#' @examples
#' \dontrun{
#' tasks()
#' }
#'
#' @export

tasks <- function(workspace_uuid = NULL,
                  workspace_owner_uuid = NULL,
                  asset_uuid = NULL,
                  assigned_to_me = FALSE,
                  created_by_me = FALSE,
                  status = c("all", "open", "cancelled", "complete"),
                  workgroup_uuid = NULL,
                  page = NULL,
                  size = NULL,
                  use_proxy = FALSE) {

  status <- rlang::arg_match(status)

  status <- if (status == "all") NULL else toupper(status)

  response <- objr(
    endpoint = "tasks",
    url_query = list(workspaceUuid = workspace_uuid,
                     workspaceOwnerUuid = workspace_owner_uuid,
                     assetUuid = asset_uuid,
                     assignedToMe = tolower(assigned_to_me),
                     createdByMe = tolower(created_by_me),
                     status = status,
                     workgroupUuid = workgroup_uuid,
                     page = page,
                     size = size),
    use_proxy = use_proxy
  )

  if (httr2::resp_body_json(response)$metadata$totalElements == 0) {
    cli::cli_warn(c(
      "!" = "No tasks match criteria.",
      "i" = "An empty tibble will be returned."
    ))
    return(dplyr::tibble())
  }

  response

}


#' Create a new task in a workspace
#'
#' @param title String. Task title.
#' @param type One of "acknowledge", "approve", "review".
#' @param workspace_uuid UUID of workspace to create task in.
#' @param assignee_uuids Optionally, a character vector of participant UUIDs
#' to assign task to.
#' @param description Optional string task description.
#' @param due_date Optionally, a `POSIXct` value to set due date of task. If no
#' time is supplied, midnight will be used. For example, if `"2025-01-01"` is
#' supplied, the due date will be `"2025-01-01 00:00:00 GMT"`
#' @param asset_uuids Optionally, a character vector of asset UUIDs to link the
#' task to.
#' @inheritParams objr
#'
#' @return UUID of new task (invisibly)
#'
#' @export

new_task <- function(title,
                     type = c("acknowledge", "approve", "review"),
                     workspace_uuid,
                     assignee_uuids,
                     description = NULL,
                     due_date = NULL,
                     asset_uuids = NULL,
                     use_proxy = FALSE) {

  type <- rlang::arg_match(type)

  response <- objr(
    endpoint = "tasks",
    method = "POST",
    body = list(
      workspaceUuid = workspace_uuid,
      type = toupper(type),
      title = title,
      assigneeUuids = as.list(assignee_uuids),
      description = description,
      dueDate = convert_to_epoch(due_date),
      assetUuids = if (!is.null(asset_uuids)) list(asset_uuids) else NULL
    ),
    use_proxy = use_proxy
  )

  if (httr2::resp_status(response) == 200) {
    cli::cli_alert_success("New task created: {.str {title}}.")
  }

  task_uuid <- httr2::resp_body_json(response)$uuid
  invisible(task_uuid)

}


#' Action a task
#'
#' @param task_uuid UUID of task to action
#' @param message Optionally, a character string to attach as a message to the
#' action.
#' @inheritParams objr
#'
#' @details Actioning a task will change the assignee status from "incomplete"
#' to "complete". If all assignees have completed the task, the task status will
#' also change to "complete".
#'
#' It is not possible to action a task if:
#' * the task has already been completed or cancelled,
#' * the task isn't assigned to the current authenticated user.
#'
#' @return API response (invisibly)
#'
#' @export

action_task <- function(task_uuid,
                        message = NULL,
                        use_proxy = FALSE) {

  response <- objr(
    method = "PUT",
    endpoint = "tasks",
    url_path = list(task_uuid, "action"),
    body = list(
      result = "true",
      message = message
    ),
    use_proxy = use_proxy
  )

  if (httr2::resp_status(response) == 204) {
    cli::cli_alert_success("Task actioned: {.field {task_uuid}}.")
  }

  invisible(response)

}


#' Cancel a task
#'
#' @param task_uuid UUID of task to cancel
#' @param message Optionally, a character string to attach as a message to the
#' cancellation.
#' @inheritParams objr
#'
#' @details Cancelling a task will change its status from "open" to "cancelled".
#'
#' @return API response (invisibly)
#'
#' @export

cancel_task <- function(task_uuid,
                        message = NULL,
                        use_proxy = FALSE) {

  response <- objr(
    method = "PUT",
    endpoint = "tasks",
    url_path = list(task_uuid, "status"),
    body = list(
      message = message,
      status = "CANCELLED"
    ),
    use_proxy = use_proxy
  )

  if (httr2::resp_status(response) == 204) {
    cli::cli_alert_success("Task cancelled: {.field {task_uuid}}.")
  }

  invisible(response)

}
