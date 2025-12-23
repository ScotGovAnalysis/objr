# Create a new thread

Create a new thread

## Usage

``` r
new_thread(
  workspace_uuid,
  text,
  mentioned_assets = NULL,
  mentioned_users = NULL,
  use_proxy = FALSE
)
```

## Arguments

- workspace_uuid:

  UUID of workspace

- text:

  Character string to include in body of thread

- mentioned_assets:

  UUID(s) of asset(s) to mention

- mentioned_users:

  UUID(s) of user(s) to mention

- use_proxy:

  Logical to indicate whether to use proxy.

## Value

API response (invisibly)

## Details

More details on this endpoint are available in the [API
documentation](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Comments/createThread).

## See also

Other Comment functions:
[`comments()`](https://ScotGovAnalysis.github.io/objr/dev/reference/comments.md),
[`new_reply()`](https://ScotGovAnalysis.github.io/objr/dev/reference/new_reply.md)
