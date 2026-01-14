#' Guess function for reading or writing temp file
#'
#' @param file_type One of "csv", "rds", "xlsx" or "parquet".
#' @param fn_type Either "read" or "write".
#'
#' @return Character string of function; e.g. "readr::write_csv". For "csv" and
#' "rds" files, `readr` functions will be used; for "xlsx" file types,
#' `writexl` will be used; for "parquet" files, `nanoparquet` will be used.
#'
#' @example write_fn("rds", "read")
#'
#' @noRd

guess_fn <- function(file_type = c("csv", "rds", "xlsx", "parquet"),
                     fn_type = c("read", "write"),
                     error_call = rlang::caller_env()) {

  file_type <- rlang::arg_match(file_type, error_call = error_call)
  fn_type   <- rlang::arg_match(fn_type, error_call = error_call)

  dplyr::case_match(
    file_type,
    c("csv", "rds") ~ paste0("readr::", fn_type, "_", file_type),
    "xlsx" ~ paste0(fn_type, "xl::", fn_type, "_", file_type),
    "parquet" ~ paste0("nanoparquet::", fn_type, "_", file_type)
  )

}


#' Write temporary data file
#'
#' @param x Data frame.
#' @param name Name to give file.
#' @param file_type File extension to give file.
#' @param ... Additional arguments to pass to `write_fn`.
#'
#' @return Character string of path to temporary file.
#'
#' @noRd

write_temp <- function(x,
                       file_name,
                       file_type,
                       ...,
                       error_call = rlang::caller_env()) {

  path <- file.path(tempdir(check = TRUE),
                    paste0(file_name, ".", file_type))

  write_fn <- parse(text = guess_fn(file_type,
                                    "write",
                                    error_call = error_call))

  eval(write_fn)(x, path, ...)

  path

}


#' Read temporary data file
#'
#' @param x Path to temporary file
#' @param ... Additional arguments to pass to read function.
#'
#' @return Data frame or R object from file.
#'
#' @noRd

read_temp <- function(x, ..., error_call = rlang::caller_env()) {

  read_fn <- parse(text = guess_fn(tools::file_ext(x),
                                   "read",
                                   error_call = error_call))

  eval(read_fn)(x, ...)

}


#' Check file exists
#'
#' @param path File path
#'
#' @return {.arg path} invisibly. Error if file doesn't exist at path.
#'
#' @noRd

check_file_exists <- function(path,
                              error_call = rlang::caller_env(),
                              error_arg = rlang::caller_arg(path)) {

  if (!file.exists(path)) {

    cli::cli_abort(
      c(
        "{.arg {error_arg}} must exist.",
        "Can't find file at {.path {path}}."
      ),
      call = error_call
    )

  }

  invisible(path)

}


#' Create file for download
#'
#' @param folder File path of folder to create file in
#'
#' @return File path of file created (invisibly).
#'
#' @noRd

create_file <- function(folder,
                        error_call = rlang::caller_env()) {

  folder <- gsub("\\/*$", "", folder)

  if (!dir.exists(folder)) {

    cli::cli_abort(
      "Can't find folder at {.code {folder}}.",
      call = error_call
    )

  }

  path <- tempfile(tmpdir = folder)

  file.create(path)

  invisible(path)

}


#' Rename downloaded file
#'
#' @param temp_path Temporary path of file downloaded.
#' @param response An httr2 [httr2::response()][response]. Must contain
#' 'Content-Disposition' header.
#' @param new_file_name Optional name to give downloaded file. If not provided,
#' file will have same name as Objective Connect asset.
#' @param overwrite Logical to indicate whether to overwrite file if already
#' exists. Defaults to `FALSE`.
#' @param ext_only Logical to indicate whether to assign a file extension only,
#' and not replace the full file name. Defaults to `FALSE`.
#'
#' @return File path of renamed file (invisibly).
#'
#' @noRd

rename_file <- function(temp_path,
                        response,
                        new_file_name = NULL,
                        overwrite = FALSE,
                        ext_only = FALSE,
                        error_call = rlang::caller_env(),
                        error_arg_file_name = rlang::caller_arg(new_file_name),
                        error_arg_overwrite  = rlang::caller_arg(overwrite),
                        error_arg_path = rlang::caller_arg(temp_path)) {

  if (!file.exists(temp_path)) {
    cli::cli_abort(
      c(
        "{.arg {error_arg_path}} must exist.",
        "No file found: {.path {temp_path}}."
      ),
      call = error_call
    )
  }

  file_name <- file_name_from_header(response)

  if (!ext_only &&
        !is.null(new_file_name) &&
        tools::file_ext(new_file_name) != "") {
    cli::cli_abort(
      c(
        "x" = "{.arg {error_arg_file_name}} must not include a file extension.",
        "i" = paste("{.arg {error_arg_file_name}} ends with",
                    "{.str .{tools::file_ext(new_file_name)}}.")
      ),
      call = error_call
    )
  }

  # Derive new file name
  if (ext_only) {
    file_name <- paste0(basename(temp_path), ".", tools::file_ext(file_name))
  } else if (!is.null(new_file_name)) {
    file_name <- paste0(
      new_file_name, ".", tools::file_ext(file_name)
    )
  }

  new_path <- file.path(dirname(temp_path), file_name)

  if (file.exists(new_path) && overwrite == FALSE) {
    cli::cli_abort(
      c(
        "File already exists: {.path {new_path}}.",
        "i" = "To overwrite, set {.code {error_arg_overwrite} = TRUE}."
      ),
      call = error_call
    )
  }

  file.rename(from = temp_path, to = new_path)

  invisible(new_path)

}


file_name_from_header <- function(response,
                                  error_call = rlang::caller_env(),
                                  error_arg  = rlang::caller_arg(response)) {

  if (!httr2::resp_header_exists(response, "Content-Disposition")) {
    cli::cli_abort(
      "{.arg {error_arg}} must contain `Content-Disposition` header.",
      call = error_call
    )
  }

  cont_disp <- httr2::resp_header(response, "Content-Disposition")

  file_name <-
    regmatches(
      cont_disp,
      m = regexpr("(?<=filename=\\\").*(?=\\\")", cont_disp, perl = TRUE)
    ) %>%
    utils::URLdecode()

  if (length(file_name) == 0) {
    cli::cli_abort(
      c(
        "`Content-Disposition` header must contain file name.",
        "i" = "Expected format: filename=\\\"my_file.csv\\\""
      ),
      call = error_call
    )
  }

  file_name

}
