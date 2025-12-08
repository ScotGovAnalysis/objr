# Get workspaces the current user is a member of

Get workspaces the current user is a member of

## Usage

``` r
workspaces(workgroup_uuid = NULL, page = NULL, size = NULL, use_proxy = FALSE)
```

## Arguments

- workgroup_uuid:

  UUID of workgroup to filter by

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
documentation](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Workspaces/getMyWorkspaces).
