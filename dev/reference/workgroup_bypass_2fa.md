# Allow/disallow bypassing of two-factor authentication for workgroup

Allow/disallow bypassing of two-factor authentication for workgroup

## Usage

``` r
workgroup_bypass_2fa(workgroup_uuid, allow_bypass = TRUE, use_proxy = FALSE)
```

## Arguments

- workgroup_uuid:

  Workgroup UUID

- allow_bypass:

  Logical to indicate whether the workgroup should allow selected
  participants to bypass two-factor authentication verification.

- use_proxy:

  Logical to indicate whether to use proxy.

## Value

API response (invisibly)

## Details

More information on two-factor authentication can be found in
[`vignette("two-factor")`](https://ScotGovAnalysis.github.io/objr/dev/articles/two-factor.md).

More details on this endpoint are available in the [API
documentation](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Workgroups/setWorkgroupMfaBypassAllowed).

## See also

Other Two-factor authentication functions:
[`participant_bypass_2fa()`](https://ScotGovAnalysis.github.io/objr/dev/reference/participant_bypass_2fa.md),
[`workgroup_mandate_2fa()`](https://ScotGovAnalysis.github.io/objr/dev/reference/workgroup_mandate_2fa.md)
