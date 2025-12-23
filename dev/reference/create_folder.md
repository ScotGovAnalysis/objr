# Create a new folder

Create a new folder

## Usage

``` r
create_folder(
  folder_name,
  workspace_uuid,
  description = NULL,
  parent_uuid = NULL,
  use_proxy = FALSE
)
```

## Arguments

- folder_name:

  Name to give new folder

- workspace_uuid:

  UUID of the workspace to create the new folder in

- description:

  Optional description of folder

- parent_uuid:

  UUID of another folder in the workspace to create the new folder
  within. If not supplied, the folder will be created in the top-level
  of the workspace.

- use_proxy:

  Logical to indicate whether to use proxy.

## Value

API response (invisibly)

## Details

More details on this endpoint are available in the [API
documentation](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/createFolder).

## See also

Other Asset functions:
[`asset_info()`](https://ScotGovAnalysis.github.io/objr/dev/reference/asset_info.md),
[`assets()`](https://ScotGovAnalysis.github.io/objr/dev/reference/assets.md),
[`delete_asset()`](https://ScotGovAnalysis.github.io/objr/dev/reference/delete_asset.md),
[`rename_asset()`](https://ScotGovAnalysis.github.io/objr/dev/reference/rename_asset.md)
