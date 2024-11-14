download_helper <- function(document_uuid,
                            folder,
                            asset_type = c("documents", "documentversions"),
                            download_type = c("download", "read"),
                            ...,
                            overwrite = FALSE,
                            use_proxy = FALSE) {

  asset_type <- rlang::arg_match(asset_type)
  download_type <- rlang::arg_match(download_type)

  # Create temporary file in desired folder
  path <- create_file(folder)

  response <- objr(
    endpoint = asset_type,
    url_path = list(document_uuid, "download"),
    method = "GET",
    path = path,
    use_proxy = use_proxy
  )

  # Rename file to match asset name
  new_path <- rename_file(path, response, overwrite = overwrite) # nolint: object_usage_linter

  if (download_type == "download") {

    # Show success message and return response invisibly
    if (httr2::resp_status(response) == 200) {
      cli::cli_alert_success("File downloaded: {.path {new_path}}.")
    }

    invisible(response)

  }

  if (download_type == "read") {

    # Read data from file path
    x <- read_temp(new_path, ...)

    # Delete temp file when exiting function
    on.exit(unlink(c(path, new_path)), add = TRUE)

    x

  }

}


#' Download a file and save to disk
#'
#' @description
#' * Use `download_file()` with an asset UUID for the latest version of a
#'   document.
#' * Use `download_file_version()` with a document version UUID for a specific
#'   version of a document.
#'
#' @details
#' More details on the endpoints used by these functions are available in the
#' API documentation:
# nolint start: line_length_linter
#' * \href{https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/download}{`download_file`}
#' * \href{https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/downloadVersion}{`download_file_version`}
# nolint end
#'
#' @param document_uuid UUID of asset or document version
#' @param folder Folder to save downloaded file to
#' @param overwrite Logical to indicate whether file should be overwritten if
#' already exists. Defaults to `FALSE`.
#' @inheritParams objr
#'
#' @return An httr2 [httr2::response()][response] (invisibly)
#'
#' @export

download_file <- function(document_uuid,
                          folder,
                          overwrite = FALSE,
                          use_proxy = FALSE) {

  download_helper(document_uuid,
                  folder,
                  asset_type = "documents",
                  download_type = "download",
                  overwrite = overwrite,
                  use_proxy = use_proxy)

}


#' @export
#' @rdname download_file

download_file_version <- function(document_uuid,
                                  folder,
                                  overwrite = FALSE,
                                  use_proxy = FALSE) {

  download_helper(document_uuid,
                  folder,
                  asset_type = "documentversions",
                  download_type = "download",
                  overwrite = overwrite,
                  use_proxy = use_proxy)

}


#' Read a data file into R
#'
#' @description
#' * Use `read_data()` with an asset UUID for the latest version of a document.
#' * Use `read_data_version()` with a document version UUID for a specific
#'   version of a document.
#'
#' @details
#' This function can be used to read the following data file types:
#' csv, rds, xlsx.
#'
#' The function works by downloading the file from Objective Connect to a
#' temporary file and reading it into R. The following functions are used to
#' read the data and any additional arguments (`...`) will be passed to these.
#'
#' | File Type | Function |
#' | --- | --- |
#' | csv | \code{readr::read_csv()} |
#' | rds | \code{readr::read_rds()} |
#' | xlsx | \code{readxl::read_xlsx()} |
#'
#' To check what file type your document is (and thus what function additional
#' arguments will be passed to), use \code{asset_info()}.
#'
# nolint start: line_length_linter
#' If there are other data file types you would like to download using this
#' function, please \href{https://github.com/ScotGovAnalysis/objr/issues/new}{open an issue on the GitHub repository}.
# nolint end
#'
#' More details on the endpoints used by these functions are available in the
#' API documentation:
# nolint start: line_length_linter
#' * \href{https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/download}{`read_data`}
#' * \href{https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/downloadVersion}{`read_data_version`}
# nolint end
#'
#' @param document_uuid UUID of asset or document version
#' @param ... Additional arguments passed to read function. See details.
#' @inheritParams objr
#'
#' @return For csv and xlsx files, a data frame. For rds files, an R object.
#'
#' @export

read_data <- function(document_uuid,
                      ...,
                      use_proxy = FALSE) {

  download_helper(document_uuid,
                  folder = tempdir(check = TRUE),
                  asset_type = "documents",
                  download_type = "read",
                  ...,
                  overwrite = FALSE,
                  use_proxy = use_proxy)

}


#' @export
#' @rdname read_data

read_data_version <- function(document_uuid,
                              ...,
                              use_proxy = FALSE) {

  download_helper(document_uuid,
                  folder = tempdir(check = TRUE),
                  asset_type = "documentversions",
                  download_type = "read",
                  ...,
                  overwrite = FALSE,
                  use_proxy = use_proxy)

}
