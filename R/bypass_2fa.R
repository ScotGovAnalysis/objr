#' Allow/disallow bypassing of two factor authentication for workgroup
#'
#' @param workgroup_uuid Workgroup UUID
#' @param allow_bypass Logical to indicate whether the workgroup should allow
#' selected participants to bypass two step workspace verification.
#' @inheritParams objectiveR
#'
#' @export

allow_bypass_2fa <- function(workgroup_uuid,
                             allow_bypass = TRUE,
                             use_proxy = FALSE) {

  response <- objectiveR(
    endpoint = paste("workgroups", workgroup_uuid, "bypassTwoStepAllowed",
                     sep = "/"),
    method = "PUT",
    bypassTwoStepAllowed = tolower(allow_bypass),
    use_proxy = use_proxy
  )

  if(httr2::resp_status(response) == 204) {
    cli::cli_alert_success(
      "Bypass 2FA setting successfully updated for workgroup."
    )
  }

  invisible(response)

}


#' Allow/disallow bypassing of two factor authentication for user
#'
#' @param user_uuid Workgroup UUID
#' @param allow_bypass Logical to indicate whether the user should be able
#' to bypass two step verification for workspace.
#' @inheritParams objectiveR
#'
#' @details Note: This setting can only be updated by a workspace owner.
#'
#' @export

user_bypass_2fa <- function(user_uuid,
                            allow_bypass = TRUE,
                            use_proxy = FALSE) {

  response <- objectiveR(
    endpoint = paste("participants", user_uuid, "bypassTwoStep",
                     sep = "/"),
    method = "PUT",
    bypassTwoStep = tolower(allow_bypass),
    use_proxy = use_proxy
  )

  if(httr2::resp_status(response) == 204) {
    cli::cli_alert_success("Bypass 2FA setting successfully updated for user.")
  }

  invisible(response)

}
