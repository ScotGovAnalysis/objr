#' Allow/disallow bypassing of two-factor authentication for workgroup
#'
#' @details
#' More information on two-factor authentication can be found in
#' `vignette("two-factor")`.
#'
#' More details on this endpoint are available in the
# nolint start: line_length_linter
#' \href{https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Workgroups/setWorkgroupMfaBypassAllowed}{API documentation}.
# nolint end
#'
#' @param workgroup_uuid Workgroup UUID
#' @param allow_bypass Logical to indicate whether the workgroup should allow
#' selected participants to bypass two-factor authentication verification.
#' @inheritParams objr
#'
#' @return API response (invisibly)
#'
#' @family Two-factor authentication functions
#'
#' @export

workgroup_bypass_2fa <- function(workgroup_uuid,
                                 allow_bypass = TRUE,
                                 use_proxy = FALSE) {

  response <- objr(
    endpoint = "workgroups",
    url_path = list(workgroup_uuid, "bypassTwoStepAllowed"),
    method = "PUT",
    body = list(bypassTwoStepAllowed = tolower(allow_bypass)),
    use_proxy = use_proxy
  )

  if (httr2::resp_status(response) == 204) {
    cli::cli_alert_success(
      "Bypass 2FA setting successfully updated for workgroup."
    )
  }

  invisible(response)

}


#' Allow/disallow bypassing of two-factor authentication for workspace
#' participant
#'
#' @details
#' This setting can only be updated by a workspace owner.
#'
#' More information on two-factor authentication can be found in
#' `vignette("two-factor")`.
#'
#' More details on this endpoint are available in the
# nolint start: line_length_linter
#' \href{https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Participants/setParticipantBypassMfa}{API documentation}.
# nolint end
#'
#' @param participant_uuid Participant UUID (note that this is different to the
#' user UUID)
#' @param allow_bypass Logical to indicate whether the participant should be
#' able to bypass two-factor authentication for workspace.
#' @inheritParams objr
#'
#' @return API response (invisibly)
#'
#' @family Two-factor authentication functions
#'
#' @export

participant_bypass_2fa <- function(participant_uuid,
                                   allow_bypass = TRUE,
                                   use_proxy = FALSE) {

  response <- objr(
    endpoint = "participants",
    url_path = list(participant_uuid, "bypassTwoStep"),
    method = "PUT",
    body = list(bypassTwoStep = tolower(allow_bypass)),
    use_proxy = use_proxy
  )

  if (httr2::resp_status(response) == 204) {
    cli::cli_alert_success(
      "Bypass 2FA setting successfully updated for participant."
    )
  }

  invisible(response)

}


#' Enable/disable mandatory two-factor authentication for workgroup
#'
#' @details
#' More information on two-factor authentication can be found in
#' `vignette("two-factor")`.
#'
#' More details on this endpoint are available in the
# nolint start: line_length_linter
#' \href{https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html#/Workgroups/setTwoStepMandatory}{API documentation}.
# nolint end
#'
#' @param workgroup_uuid Workgroup UUID
#' @param mandate Logical to indicate whether two-factor authentication should
#' be mandatory in the workgroup
#' @inheritParams objr
#'
#' @return API response (invisibly)
#'
#' @family Two-factor authentication functions
#'
#' @export

workgroup_mandate_2fa <- function(workgroup_uuid,
                                  mandate = TRUE,
                                  use_proxy = FALSE) {

  response <- objr(
    endpoint = "workgroups",
    url_path = list(workgroup_uuid, "twostepmandatory"),
    method = "PUT",
    body = list(twoStepMandatory = tolower(mandate)),
    use_proxy = use_proxy
  )

  if (httr2::resp_status(response) == 204) {
    cli::cli_alert_success(
      "Mandatory 2FA setting successfully updated for workgroup."
    )
  }

  invisible(response)

}
