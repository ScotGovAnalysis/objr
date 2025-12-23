# Add participant(s) to a workspace

Add participant(s) to a workspace

## Usage

``` r
add_participants(
  workspace_uuid,
  emails,
  message = NULL,
  permissions = NULL,
  member_visibility = c("standard", "bcc"),
  send_email_invite = TRUE,
  use_proxy = FALSE
)
```

## Arguments

- workspace_uuid:

  UUID of workspace.

- emails:

  Character vector of email addresses to send invites to.

- message:

  Optionally, a message to include in email invite.

- permissions:

  Optionally, a character vector of permissions to give invited
  participants.

  Valid permissions are: "Download", "CreateDocument", "CreateFolder",
  "Edit", "Delete", "EditOnline", "Inviter", "Commenter" and
  "ManageWorkspace".

  All members are given permission to preview documents.

- member_visibility:

  Either "standard" (default) to make new participants visible to all
  other workspace members, or "bcc" to hide participants.

- send_email_invite:

  Default `TRUE` to send an email invite for participants to join the
  workspace. If `FALSE`, no email will be sent.

- use_proxy:

  Logical to indicate whether to use proxy.

## Value

API response (invisibly)

## Details

More details on this endpoint are available in the [API
documentation](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Participants/addParticipants).

## See also

[`participants()`](https://ScotGovAnalysis.github.io/objr/dev/reference/participants.md)
