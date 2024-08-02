#' Create a new folder
#'
#' @param folder_name Name to give new folder
#' @param workspace_uuid UUID of the workspace to create the new folder in
#' @param description Optional description of folder
#' @param parent_uuid UUID of another folder in the workspace to create the new
#' folder within. If not supplied, the folder will be created in the top-level
#' of the workspace.
#' @inheritParams objr
#'
#' @export

create_folder <- function(folder_name,
                          workspace_uuid,
                          description = NULL,
                          parent_uuid = NULL,
                          use_proxy = FALSE) {

  response <- objr(
    endpoint = "folders",
    method = "POST",
    body = list(
      name = folder_name,
      workspaceUuid = workspace_uuid,
      parentUuid = parent_uuid,
      description = description
    ),
    use_proxy = use_proxy
  ) |>
    httr2::resp_body_json()

  if(tolower(response$status) == "complete") {
    cli::cli_alert_success("New folder created: {folder_name}.")
  }

  invisible(response)

}
