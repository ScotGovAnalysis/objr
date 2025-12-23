# Rename an asset

Rename an asset

## Usage

``` r
rename_asset(asset_uuid, new_name, use_proxy = FALSE)
```

## Arguments

- asset_uuid:

  UUID of asset

- new_name:

  Character. New name to give asset.

- use_proxy:

  Logical to indicate whether to use proxy.

## Value

API response (invisibly)

## Details

More details on this endpoint are available in the [API
documentation](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/updateAssetName).

## See also

Other Asset functions:
[`asset_info()`](https://ScotGovAnalysis.github.io/objr/dev/reference/asset_info.md),
[`assets()`](https://ScotGovAnalysis.github.io/objr/dev/reference/assets.md),
[`create_folder()`](https://ScotGovAnalysis.github.io/objr/dev/reference/create_folder.md),
[`delete_asset()`](https://ScotGovAnalysis.github.io/objr/dev/reference/delete_asset.md)
