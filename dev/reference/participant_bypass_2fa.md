# Allow/disallow bypassing of two-factor authentication for workspace participant

Allow/disallow bypassing of two-factor authentication for workspace
participant

## Usage

``` r
participant_bypass_2fa(
  participant_uuid,
  allow_bypass = TRUE,
  use_proxy = FALSE
)
```

## Arguments

- participant_uuid:

  Participant UUID (note that this is different to the user UUID)

- allow_bypass:

  Logical to indicate whether the participant should be able to bypass
  two-factor authentication for workspace.

- use_proxy:

  Logical to indicate whether to use proxy.

## Value

API response (invisibly)

## Details

This setting can only be updated by a workspace owner.

More information on two-factor authentication can be found in
[`vignette("two-factor")`](https://ScotGovAnalysis.github.io/objr/dev/articles/two-factor.md).

More details on this endpoint are available in the [API
documentation](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Participants/setParticipantBypassMfa).

## See also

Other Two-factor authentication functions:
[`workgroup_bypass_2fa()`](https://ScotGovAnalysis.github.io/objr/dev/reference/workgroup_bypass_2fa.md),
[`workgroup_mandate_2fa()`](https://ScotGovAnalysis.github.io/objr/dev/reference/workgroup_mandate_2fa.md)
