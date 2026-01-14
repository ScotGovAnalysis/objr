# Get data frame of document versions

Get data frame of document versions

## Usage

``` r
versions(document_uuid, page = NULL, size = NULL, use_proxy = FALSE)
```

## Arguments

- document_uuid:

  UUID of document (asset)

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
documentation](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/getVersionsByDocumentUuid).

## See also

[`rollback_to_version()`](https://ScotGovAnalysis.github.io/objr/reference/rollback_to_version.md)
