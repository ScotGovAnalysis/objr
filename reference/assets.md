# Get data frame of assets in workspace

Get data frame of assets in workspace

## Usage

``` r
assets(
  workspace_uuid,
  type = NULL,
  page = NULL,
  size = NULL,
  use_proxy = FALSE
)
```

## Arguments

- workspace_uuid:

  UUID of workspace

- type:

  Asset type to filter results by. Either "document", "folder" or
  "link". Default returns all asset types.

- page:

  Page number of responses to return (0..N). Default is 0.

- size:

  Number of results to be returned per page. Default is 20.

- use_proxy:

  Logical to indicate whether to use proxy.

## Value

A tibble

## Details

More details on this endpoint are available in the [API
documentation](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/getAssets).

## See also

Other Asset functions:
[`asset_info()`](https://ScotGovAnalysis.github.io/objr/reference/asset_info.md),
[`create_folder()`](https://ScotGovAnalysis.github.io/objr/reference/create_folder.md),
[`delete_asset()`](https://ScotGovAnalysis.github.io/objr/reference/delete_asset.md),
[`rename_asset()`](https://ScotGovAnalysis.github.io/objr/reference/rename_asset.md)
