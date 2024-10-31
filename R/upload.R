#' Upload a file
#'
#' @description
#' * Use `upload_file()` to create a new file in a workspace.
#' * Use `upload_file_version()` to create a new version of an existing
#'   document.
#'
#' @param file File path of document to upload
#' @param uuid For `upload_file()`, a workspace UUID to create the new document
#' in. For `upload_file_version()`, an asset UUID to create a new version of.
#' @param name Name to give document. If this isn't provided, the name of the
#' file will be used.
#' @param description Optional description of document.
#' @param parent_uuid UUID of folder in the workspace to create the new
#' document within. If not supplied, the document will be created in the
#' top-level of the workspace.
#' @inheritParams objr
#'
#' @return API response (invisibly)
#'
#' @export

upload_file <- function(file,
                        uuid,
                        name = NULL,
                        description = NULL,
                        parent_uuid = NULL,
                        use_proxy = FALSE) {

  check_file_exists(file)

  # If name not provided, use file name
  name <- if (is.null(name)) {
    tools::file_path_sans_ext(basename(file))
  } else {
    name
  }

  response <- objr(
    endpoint = "documents",
    method = "POST",
    content_type = "multipart/form-data",
    body = list(
      name = curl::form_data(name),
      description = form_data_null(description),
      workspaceUuid = curl::form_data(uuid),
      parentUuid = form_data_null(parent_uuid),
      file = curl::form_file(file)
    ),
    use_proxy = use_proxy
  )

  if (httr2::resp_status(response) == 200) {
    cli::cli_alert_success(
      "New document created: {paste(name, tools::file_ext(file), sep = \".\")}."
    )
  }

  invisible(response)

}


#' @export
#' @rdname upload_file

upload_file_version <- function(file,
                                uuid,
                                use_proxy = FALSE) {

  check_file_exists(file)

  response <- objr(
    endpoint = "documents",
    url_path = list(uuid, "upload"),
    method = "POST",
    content_type = "multipart/form-data",
    body = list(file = curl::form_file(file)),
    use_proxy = use_proxy
  )

  # Get asset info
  info <- asset_info(uuid) # nolint: object_usage_linter

  if (httr2::resp_status(response) == 204) {
    cli::cli_alert_success(paste(
      "New version created:",
      "{paste(info$asset_name, info$asset_ext, sep = \".\")}."
    ))
  }

  invisible(response)

}


#' Write a data file from R
#'
#' @description
#' * Use `write_data()` to create a new file in a workspace.
#' * Use `write_data_version()` to write a data file as a new version of an
#'   existing document.
#'
#' @param x R object to write to file.
#' @param uuid Either a workspace UUID to create a new document or an asset UUID
#' to create a new version of an existing document.
#' @param file_name Name to give file.
#' @param file_type Either "csv", "rds" or "xlsx".
#' @param ... Additional arguments to pass to write function. See details.
#' @inheritParams objr
#' @inheritParams upload_file
#'
#' @details This function can be used to write the following data file types:
#' csv, rds, xlsx. If writing to a new document, use the \code{file_type}
#' argument to control which file type to create. If writing a new version of an
#' existing document, the existing file type will be used.
#'
#' The function works by writing the R object to a temporary file and uploading
#' the file to Objective Connect. The following functions are used to
#' write the data and any additional arguments (`...`) will be passed to these.
#'
#' | File Type | Function |
#' | --- | --- |
#' | csv | \code{readr::write_csv()} |
#' | rds | \code{readr::write_rds()} |
#' | xlsx | \code{writexl::write_xlsx()} |
#'
# nolint start: line_length_linter
#' If there are other data file types you would like to upload using this
#' function, please \href{https://github.com/ScotGovAnalysis/objr/issues/new}{open an issue on the GitHub repository}.
# nolint end
#'
#' @return API response (invisibly)
#'
#' @export

write_data <- function(x,
                       uuid,
                       file_name,
                       file_type,
                       ...,
                       description = NULL,
                       parent_uuid = NULL,
                       use_proxy = FALSE) {

  # Write data to temporaty file
  path <- write_temp(x, file_name = file_name, file_type = file_type, ...)

  # Delete temp file when exiting function
  on.exit(unlink(path), add = TRUE)

  resp <- upload_file(path,
                      uuid = uuid,
                      description = description,
                      parent_uuid = parent_uuid,
                      use_proxy = FALSE)

  invisible(resp)

}


#' @export
#' @rdname write_data

write_data_version <- function(x,
                               uuid,
                               ...,
                               use_proxy = FALSE) {

  # Get asset info
  info <- asset_info(uuid)

  path <- write_temp(x,
                     file_name = info$asset_name,
                     file_type = info$asset_ext,
                     ...)

  # Delete temp file when exiting function
  on.exit(unlink(path), add = TRUE)

  resp <- upload_file_version(path,
                              uuid,
                              use_proxy = use_proxy)

  invisible(resp)

}
