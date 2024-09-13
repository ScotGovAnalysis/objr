#' Guess function for reading or writing temp file
#'
#' @param file_type Either "csv", "rds" or "xlsx".
#' @param fn_type Either "read" or "write".
#'
#' @return Character string of function; e.g. "readr::write_csv". For "csv" and
#' "rds" files, `readr` functions will be used, and for "xlsx" file types,
#' `writexl` will be used.
#'
#' @example write_fn("rds", "read")
#'
#' @noRd

guess_fn <- function(file_type = c("csv", "rds", "xlsx"),
                     fn_type = c("read", "write"),
                     error_call = rlang::caller_env()) {

  file_type <- rlang::arg_match(file_type, error_call = error_call)
  fn_type   <- rlang::arg_match(fn_type, error_call = error_call)

  if(file_type == "xlsx") {
    paste0(fn_type, "xl::", fn_type, "_", file_type)
  } else {
    paste0("readr::", fn_type, "_", file_type)
  }

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
                              error_call = rlang::caller_env()) {

  if (!file.exists(path)) {

    cli::cli_abort(
      "Can't find file at {.code {path}}.",
      call = error_call
    )

  }

  invisible(path)

}
