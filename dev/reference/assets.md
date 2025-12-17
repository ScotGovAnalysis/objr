# Get data frame of assets in workspace

Get data frame of assets in workspace

## Usage

``` r
assets(
  workspace_uuid,
  type = list(),
  page = NULL,
  size = NULL,
  use_proxy = FALSE
)
```

## Arguments

- workspace_uuid:

  UUID of workspace

- type:

  List of asset types to return. Default returns all types; "document",
  "folder" and "link".

  List must be empty (default, returns all asset types), or length 1
  (e.g. `list("document")`). This is a temporary measure while a bug in
  the underlying API is outstanding (see
  [objr#53](https://github.com/ScotGovAnalysis/objr/issues/53)).

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
