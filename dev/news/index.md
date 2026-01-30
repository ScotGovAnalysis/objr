# Changelog

## objr (development version)

## objr 0.2.1

- Fix bug when downloaded files have MIME-encoded syntax
  ([\#72](https://github.com/ScotGovAnalysis/objr/issues/72)).

## objr 0.2.0

### New features

- New
  [`mobile_auth_status()`](https://ScotGovAnalysis.github.io/objr/dev/reference/mobile_auth_status.md)
  and
  [`mobile_auth_login()`](https://ScotGovAnalysis.github.io/objr/dev/reference/mobile_auth_login.md)
  support use of [mobile
  authentication](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/MobileAuth)
  ([\#52](https://github.com/ScotGovAnalysis/objr/issues/52)).

- New
  [`workgroup_mandate_2fa()`](https://ScotGovAnalysis.github.io/objr/dev/reference/workgroup_mandate_2fa.md)
  provides ability to enable or disable mandatory two-factor
  authentication (2FA) in workgroups
  ([\#65](https://github.com/ScotGovAnalysis/objr/issues/65)).

- [`read_data()`](https://ScotGovAnalysis.github.io/objr/dev/reference/read_data.md)
  and
  [`write_data()`](https://ScotGovAnalysis.github.io/objr/dev/reference/write_data.md)
  now support reading and writing of parquet files
  ([\#54](https://github.com/ScotGovAnalysis/objr/issues/54)).

- [`download_file()`](https://ScotGovAnalysis.github.io/objr/dev/reference/download_file.md)
  gains a `file_name` argument to supply a custom name
  ([\#37](https://github.com/ScotGovAnalysis/objr/issues/37)).

### Lifecycle changes

- In
  [`assets()`](https://ScotGovAnalysis.github.io/objr/dev/reference/assets.md),
  `type` now expects a string instead of a list. This was prompted by a
  change to the underlying API, where results can now only be filtered
  by one asset type at a time
  ([\#53](https://github.com/ScotGovAnalysis/objr/issues/53)).

### Minor improvements and bug fixes

- Expiry time is now stored alongside the authentication token
  (`token`). If a token is expired, it will be removed from the Global
  Environment and authentication will be attempted with username and
  password instead
  ([\#35](https://github.com/ScotGovAnalysis/objr/issues/35)).

- [`download_file()`](https://ScotGovAnalysis.github.io/objr/dev/reference/download_file.md)
  now returns file path (invisibly)
  ([\#38](https://github.com/ScotGovAnalysis/objr/issues/38)).

- [`download_file()`](https://ScotGovAnalysis.github.io/objr/dev/reference/download_file.md)
  now writes files with percent-decoded names (e.g. `file%20name.csv` is
  now `file name.csv`)
  ([\#34](https://github.com/ScotGovAnalysis/objr/issues/34)).

- Fixed an issue where temporary files sometimes persisted after running
  [`download_file()`](https://ScotGovAnalysis.github.io/objr/dev/reference/download_file.md)
  or
  [`read_data()`](https://ScotGovAnalysis.github.io/objr/dev/reference/read_data.md)
  ([\#39](https://github.com/ScotGovAnalysis/objr/issues/39)).

## objr 0.1.1

- Set minimum versions for `dplyr` and `tidyr` dependencies
  ([\#32](https://github.com/ScotGovAnalysis/objr/issues/32)).

## objr 0.1.0

- First package release.

- Add pkgdown site (<https://ScotGovAnalysis.github.io/objr>).
