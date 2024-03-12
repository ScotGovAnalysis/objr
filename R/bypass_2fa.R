#' Allow/disallow bypassing of two factor authentication for workgroup
#'
#' @description More information on two factor authentication can be found in
#' `vignette("faqs")`.
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


#' Allow/disallow bypassing of two factor authentication for participant
#'
#' @description Note that this setting can only be updated by a workspace owner.
#' More information on two factor authentication can be found in
#' `vignette("faqs")`.
#'
#' @param participant_uuid Participant UUID (note that this is different to the
#' user UUID)
#' @param allow_bypass Logical to indicate whether the participant should be
#' able to bypass two step verification for workspace.
#' @inheritParams objectiveR
#'
#' @export

participant_bypass_2fa <- function(participant_uuid,
                                   allow_bypass = TRUE,
                                   use_proxy = FALSE) {

  response <- objectiveR(
    endpoint = paste("participants", participant_uuid, "bypassTwoStep",
                     sep = "/"),
    method = "PUT",
    bypassTwoStep = tolower(allow_bypass),
    use_proxy = use_proxy
  )

  if(httr2::resp_status(response) == 204) {
    cli::cli_alert_success(
      "Bypass 2FA setting successfully updated for participant."
    )
  }

  invisible(response)

}
