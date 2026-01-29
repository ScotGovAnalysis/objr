# objr 0.2.1

* Fix bug when downloaded files have MIME-encoded syntax (#72).

# objr 0.2.0

## New features

* New `mobile_auth_status()` and `mobile_auth_login()` support use of
[mobile authentication](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/MobileAuth)
(#52).

* New `workgroup_mandate_2fa()` provides ability to enable or disable mandatory 
two-factor authentication (2FA) in workgroups (#65).

* `read_data()` and `write_data()` now support reading and writing of parquet
files (#54).

* `download_file()` gains a `file_name` argument to supply a custom name (#37).

## Lifecycle changes

* In `assets()`, `type` now expects a string instead of a list. This was 
prompted by a change to the underlying API, where results can now only be 
filtered by one asset type at a time (#53).

## Minor improvements and bug fixes

* Expiry time is now stored alongside the authentication token (`token`). If a 
token is expired, it will be removed from the Global Environment and 
authentication will be attempted with username and password instead (#35).

* `download_file()` now returns file path (invisibly) (#38).

* `download_file()` now writes files with percent-decoded names 
(e.g. `file%20name.csv` is now `file name.csv`) (#34).

* Fixed an issue where temporary files sometimes persisted after running 
`download_file()` or `read_data()` (#39).

# objr 0.1.1

* Set minimum versions for `dplyr` and `tidyr` dependencies (#32).

# objr 0.1.0

* First package release.

* Add pkgdown site (https://ScotGovAnalysis.github.io/objr).
