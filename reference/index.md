# Package index

- [`objr()`](https://ScotGovAnalysis.github.io/objr/reference/objr.md) :
  Core request function
- [`my_user_id()`](https://ScotGovAnalysis.github.io/objr/reference/my_user_id.md)
  : Get user ID for current authenticated user

## Workspaces

Workspaces are the containers that connect a collection of documents and
folders (Assets) with a collection of Users (Participants)

- [`workspaces()`](https://ScotGovAnalysis.github.io/objr/reference/workspaces.md)
  : Get workspaces the current user is a member of
- [`participants()`](https://ScotGovAnalysis.github.io/objr/reference/participants.md)
  : Get data frame of workspace participants
- [`add_participants()`](https://ScotGovAnalysis.github.io/objr/reference/add_participants.md)
  : Add participant(s) to a workspace

## Assets

Assets represent Documents and Folders that are added to Workspaces

- [`assets()`](https://ScotGovAnalysis.github.io/objr/reference/assets.md)
  : Get data frame of assets in workspace
- [`asset_info()`](https://ScotGovAnalysis.github.io/objr/reference/asset_info.md)
  : Get asset information
- [`create_folder()`](https://ScotGovAnalysis.github.io/objr/reference/create_folder.md)
  : Create a new folder
- [`rename_asset()`](https://ScotGovAnalysis.github.io/objr/reference/rename_asset.md)
  : Rename an asset
- [`delete_asset()`](https://ScotGovAnalysis.github.io/objr/reference/delete_asset.md)
  : Delete an asset

### Document versions

- [`versions()`](https://ScotGovAnalysis.github.io/objr/reference/versions.md)
  : Get data frame of document versions
- [`rollback_to_version()`](https://ScotGovAnalysis.github.io/objr/reference/rollback_to_version.md)
  : Rollback a document to a previous version

### Download

- [`download_file()`](https://ScotGovAnalysis.github.io/objr/reference/download_file.md)
  [`download_file_version()`](https://ScotGovAnalysis.github.io/objr/reference/download_file.md)
  : Download a file and save to disk
- [`read_data()`](https://ScotGovAnalysis.github.io/objr/reference/read_data.md)
  [`read_data_version()`](https://ScotGovAnalysis.github.io/objr/reference/read_data.md)
  : Read a data file into R

### Upload

- [`upload_file()`](https://ScotGovAnalysis.github.io/objr/reference/upload_file.md)
  [`upload_file_version()`](https://ScotGovAnalysis.github.io/objr/reference/upload_file.md)
  : Upload a file
- [`write_data()`](https://ScotGovAnalysis.github.io/objr/reference/write_data.md)
  [`write_data_version()`](https://ScotGovAnalysis.github.io/objr/reference/write_data.md)
  : Write a data file from R

## Comments

View comments and create new threads and replies in workspaces

- [`comments()`](https://ScotGovAnalysis.github.io/objr/reference/comments.md)
  : Get comments for workspaces of current user
- [`new_thread()`](https://ScotGovAnalysis.github.io/objr/reference/new_thread.md)
  : Create a new thread
- [`new_reply()`](https://ScotGovAnalysis.github.io/objr/reference/new_reply.md)
  : Create a new reply to a thread

## Authentication

### Two-factor authentication

See
[`vignette("two-factor")`](https://ScotGovAnalysis.github.io/objr/articles/two-factor.md)
for more information.

- [`workgroup_mandate_2fa()`](https://ScotGovAnalysis.github.io/objr/reference/workgroup_mandate_2fa.md)
  : Enable/disable mandatory two-factor authentication for workgroup
- [`workgroup_bypass_2fa()`](https://ScotGovAnalysis.github.io/objr/reference/workgroup_bypass_2fa.md)
  : Allow/disallow bypassing of two-factor authentication for workgroup
- [`participant_bypass_2fa()`](https://ScotGovAnalysis.github.io/objr/reference/participant_bypass_2fa.md)
  : Allow/disallow bypassing of two-factor authentication for workspace
  participant

### Mobile authentication

See vignette for more information.

- [`mobile_auth_status()`](https://ScotGovAnalysis.github.io/objr/reference/mobile_auth_status.md)
  : Get mobile authenticator details of the current authenticated user
- [`mobile_auth_login()`](https://ScotGovAnalysis.github.io/objr/reference/mobile_auth_login.md)
  : Login using mobile authenticator
