# Rollback a document to a previous version

Rollback a document to a previous version

## Usage

``` r
rollback_to_version(document_uuid, version_uuid, use_proxy = FALSE)
```

## Arguments

- document_uuid:

  UUID of document (asset)

- version_uuid:

  UUID of version to rollback to

- use_proxy:

  Logical to indicate whether to use proxy.

## Value

API response (invisibly)

## Details

More details on this endpoint are available in the [API
documentation](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/rollbackDocument).

## See also

[`versions()`](https://ScotGovAnalysis.github.io/objr/reference/versions.md)
