# Enable/disable mandatory two-factor authentication for workgroup

Enable/disable mandatory two-factor authentication for workgroup

## Usage

``` r
workgroup_mandate_2fa(workgroup_uuid, mandate = TRUE, use_proxy = FALSE)
```

## Arguments

- workgroup_uuid:

  Workgroup UUID

- mandate:

  Logical to indicate whether two-factor authentication should be
  mandatory in the workgroup

- use_proxy:

  Logical to indicate whether to use proxy.

## Value

API response (invisibly)

## Details

More information on two-factor authentication can be found in
[`vignette("two-factor")`](https://ScotGovAnalysis.github.io/objr/dev/articles/two-factor.md).

More details on this endpoint are available in the [API
documentation](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html#/Workgroups/setTwoStepMandatory).
