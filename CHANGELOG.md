# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - YYYY-MM-DD

### Added

- export servo MBeans with JMX Prometheus exporter [#65](https://github.com/Telecominfraproject/wlan-cloud-helm/pull/65)
- render post-deployment message [#73](https://github.com/Telecominfraproject/wlan-cloud-helm/pull/73)

## [1.0.1] - 2021-04-12

### Changed

- bump cloud controller version to 1.0.1

### Fixed

- correct SQL and CQL schema URLs

## [1.0.0] - 2021-04-01

### Added

- replaced cassandra, postgres and kafka with upstream charts [#49](https://github.com/Telecominfraproject/wlan-cloud-helm/pull/49)
- centralized secrets to the parent chart [#54](https://github.com/Telecominfraproject/wlan-cloud-helm/pull/54)

### Changed

- improved kafka setup templating [#53](https://github.com/Telecominfraproject/wlan-cloud-helm/pull/53)
- improved values.yaml [#53](https://github.com/Telecominfraproject/wlan-cloud-helm/pull/53)
- improved default values and added yaml anchors [#54](https://github.com/Telecominfraproject/wlan-cloud-helm/pull/54)

### Removed

- removed hardcoded docker secret in favor of variables [#53](https://github.com/Telecominfraproject/wlan-cloud-helm/pull/53)
- various outdated sections in values.yaml and environment files
- various secrets in subcharts as they are now part of the parent chart
- references to vendor specific values [#40](https://github.com/Telecominfraproject/wlan-cloud-helm/pull/40)

### Fixed

- make SSC service able to reconnect to Cassandra [#70](https://github.com/Telecominfraproject/wlan-cloud-helm/pull/70)

## [0.4.0] - 2021-01-28

### Added

- initial changelog entry. This is the first versioned release. Next releases will include a detailed overview of all the major changes introduced since the last version.
- [changes since first commit](https://github.com/Telecominfraproject/wlan-cloud-helm/compare/f7c67645736e3dac498e2caec8c267f04d08b7bc...v0.4)
