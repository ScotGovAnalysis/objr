#' Create a new folder
#'
#' @param folder_name Name to give new folder
#' @param workspace_uuid UUID of the workspace to create the new folder in
#' @param folder_description Optional description of folder
#' @param parent_uuid UUID of another folder in the workspace to create the new
#' folder within. If not supplied, the folder will be created in the top-level
#' of the workspace.
#' @inheritParams objectiveR
#'
#' @export

create_folder <- function(folder_name,
                          workspace_uuid,
                          folder_description = NULL,
                          parent_uuid = NULL,
                          use_proxy = FALSE) {

  response <- objectiveR(
    "folders",
    method = "POST",
    name = folder_name,
    workspaceUuid = workspace_uuid,
    parentUuid = parent_uuid,
    description = folder_description,
    use_proxy = use_proxy
  )

  if(tolower(response$status) == "complete") {
    cli::cli_alert_success("New folder created: {folder_name}.")
  }

  invisible(response)

}
