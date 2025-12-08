# Get comments for workspaces of current user

Get comments for workspaces of current user

## Usage

``` r
comments(
  created_after = NULL,
  thread_uuid = NULL,
  mention_uuid = NULL,
  workgroup_uuid = NULL,
  page = NULL,
  size = NULL,
  use_proxy = FALSE
)
```

## Arguments

- created_after:

  Date (and optionally time) to filter comments created since this
  date/time. If a time is not supplied, all comments made on this day
  will be included.

- thread_uuid:

  UUID of thread to filter by

- mention_uuid:

  UUID of user to filter comments where mentioned

- workgroup_uuid:

  UUID of workgroup to filter by

- page:

  Page number of responses to return (0..N). Default is 0.

- size:

  Number of results to be returned per page. Default is 20.

- use_proxy:

  Logical to indicate whether to use proxy

## Value

A tibble

## Details

More details on this endpoint are available in the [API
documentation](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Comments/getComments).

## Examples

``` r
if (FALSE) { # \dontrun{
comments()
} # }
```
