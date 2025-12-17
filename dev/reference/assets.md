# Get data frame of assets in workspace

Get data frame of assets in workspace

## Usage

``` r
assets(
  workspace_uuid,
  type = list("document", "folder", "link"),
  page = NULL,
  size = NULL,
  use_proxy = FALSE
)
```

## Arguments

- workspace_uuid:

  UUID of workspace

- type:

  List of asset types to return. Defaults to all types; document, folder
  and link.

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
