#' Upload a new document
#'
#' @param file File path of document to upload
#' @param name Name to give document. If this isn't provided, the name of the
#' file will be used.
#' @param workspace_uuid UUID of the workspace to create the new document in
#' @param description Optional description of document
#' @param parent_uuid UUID of folder in the workspace to create the new
#' document within. If not supplied, the document will be created in the
#' top-level of the workspace.
#' @inheritParams objectiveR
#'
#' @export

upload_file <- function(file,
                        name = NULL,
                        workspace_uuid,
                        description = NULL,
                        parent_uuid = NULL,
                        use_proxy = FALSE) {

  # If name not provided, use file name
  name <- if(is.null(name)) {
    tools::file_path_sans_ext(basename(file))
  } else {name}

  name_with_ext <- paste0(name, ".", tools::file_ext(file))

  response <- objectiveR(
    endpoint = "documents",
    method = "POST",
    content_type = "multipart/form-data",
    file = curl::form_file(file),
    name = name,
    description = description,
    workspaceUuid = workspace_uuid,
    parentUuid = parent_uuid,
    use_proxy = use_proxy
  ) |>
    httr2::resp_body_json()

  if(tolower(response$status) == "complete") {
    cli::cli_alert_success("New file created: {name_with_ext}.")
  }

  invisible(response)

}
