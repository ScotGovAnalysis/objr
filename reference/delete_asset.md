# Delete an asset

Delete an asset

## Usage

``` r
delete_asset(asset_uuid, use_proxy = FALSE)
```

## Arguments

- asset_uuid:

  UUID of asset

- use_proxy:

  Logical to indicate whether to use proxy.

## Value

API response (invisibly)

## Details

More details on this endpoint are available in the [API
documentation](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/deleteAsset).

Note: This functionality is disabled in Scottish Government workspaces.

## See also

Other Asset functions:
[`asset_info()`](https://ScotGovAnalysis.github.io/objr/reference/asset_info.md),
[`assets()`](https://ScotGovAnalysis.github.io/objr/reference/assets.md),
[`create_folder()`](https://ScotGovAnalysis.github.io/objr/reference/create_folder.md),
[`rename_asset()`](https://ScotGovAnalysis.github.io/objr/reference/rename_asset.md)
