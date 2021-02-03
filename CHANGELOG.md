# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased](xxx) - 2021-02-04

### Added

- Replaced cassandra, postgres and kafka with upstream charts ( https://github.com/Telecominfraproject/wlan-cloud-helm/pull/49 )
- Removed hardcoded docker secret in favor of variables ( https://github.com/Telecominfraproject/wlan-cloud-helm/pull/53 )

### Replaced
- Centralized secrets to the parent chart ( https://github.com/Telecominfraproject/wlan-cloud-helm/pull/54 )
- Improved kafka setup templating ( https://github.com/Telecominfraproject/wlan-cloud-helm/pull/53 )
- Improved values.yaml ( https://github.com/Telecominfraproject/wlan-cloud-helm/pull/53 )
- Improved default values and added yaml anchors ( https://github.com/Telecominfraproject/wlan-cloud-helm/pull/54 )

### Removed
- Various outdated sections in values.yaml and environment files
- Various secrets in subcharts as they are now part of the parent chart

## [0.4.0](https://github.com/Telecominfraproject/wlan-cloud-helm/compare/f7c67645736e3dac498e2caec8c267f04d08b7bc...v0.4) - 2021-01-28

### Added

- Initial changelog entry. This is the first versioned release. Next releases will include a detailed overview of all the major changes introduced since the last version.

