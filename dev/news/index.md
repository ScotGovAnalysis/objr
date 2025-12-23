# Changelog

## objr (development version)

- Added `CONTRIBUTING.md` and `SUPPORT.md`
  ([\#36](https://github.com/ScotGovAnalysis/objr/issues/36)).

- [`download_file()`](https://ScotGovAnalysis.github.io/objr/dev/reference/download_file.md)
  now returns file path (invisibly)
  ([\#38](https://github.com/ScotGovAnalysis/objr/issues/38)).

- [`download_file()`](https://ScotGovAnalysis.github.io/objr/dev/reference/download_file.md)
  now accepts custom file name in `file_name` argument
  ([\#37](https://github.com/ScotGovAnalysis/objr/issues/37)).

- [`download_file()`](https://ScotGovAnalysis.github.io/objr/dev/reference/download_file.md)
  now writes files with percent-decoded names (e.g. `file%20name.csv` is
  now `file name.csv`)
  ([\#34](https://github.com/ScotGovAnalysis/objr/issues/34)).

- Fixed an issue where temporary files sometimes persisted after running
  [`download_file()`](https://ScotGovAnalysis.github.io/objr/dev/reference/download_file.md)
  or
  [`read_data()`](https://ScotGovAnalysis.github.io/objr/dev/reference/read_data.md)
  ([\#39](https://github.com/ScotGovAnalysis/objr/issues/39)).

- Added support for parquet files in `read/write_data` and
  `read/write_data_version()`([\#54](https://github.com/ScotGovAnalysis/objr/issues/54)).

- Added support for [mobile
  authentication](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/MobileAuth)
  to view status (`mobile_auth_staus()`) and to login
  ([`mobile_auth_login()`](https://ScotGovAnalysis.github.io/objr/dev/reference/mobile_auth_login.md))
  ([\#52](https://github.com/ScotGovAnalysis/objr/issues/52)).

- Temporary fix to
  [`assets()`](https://ScotGovAnalysis.github.io/objr/dev/reference/assets.md)
  to account for bug in underlying API
  ([\#53](https://github.com/ScotGovAnalysis/objr/issues/53)). The
  `type` argument now only accepts an empty list (default to return all
  asset types) or a list of length 1.

- New
  [`workgroup_mandate_2fa()`](https://ScotGovAnalysis.github.io/objr/dev/reference/workgroup_mandate_2fa.md)
  provides ability to enable or disable mandatory two-factor
  authentication (2FA) in workgroups
  ([\#65](https://github.com/ScotGovAnalysis/objr/issues/65)).

- Expiry time is now stored alongside the authentication token
  (`token`). If a token is expired, it will be removed from the Global
  Environment and authentication will be attempted with username and
  password instead
  ([\#35](https://github.com/ScotGovAnalysis/objr/issues/35)).

## objr 0.1.1

- Set minimum versions for `dplyr` and `tidyr` dependencies
  ([\#32](https://github.com/ScotGovAnalysis/objr/issues/32)).

## objr 0.1.0

- First package release.

- Add pkgdown site (<https://ScotGovAnalysis.github.io/objr>).
