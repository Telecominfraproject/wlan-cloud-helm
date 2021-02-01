# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.1]()

values files changes:
1. removed dockerRegistrySecret property as obsolete from environment values files
2. removed annotations property as obsolete from environment values files
3. moved scalabilty property completely to base values.yaml to not repeat this in values files
4. updated multi-namespace examples to support latest changes
5. removed passwords\certificates from environment values files

other changes:
1. centralized passwords in helm values
2. centralized certificates secrets in parent chart 
3. removed .Values.creds.enabled conditions, because they do not make sense, none of the services using those conditions would properly work without those
4. added startup probes to prevent container restarts during startup process
5. defaulting most of the properties to values.yaml
5. not templating around files.glob where not needed
6. minor formatting fixes
7. fixed multi-namepsace examples

## [0.4.0](https://github.com/Telecominfraproject/wlan-cloud-helm/compare/f7c67645736e3dac498e2caec8c267f04d08b7bc...v0.4) - 2021-01-28

### Added

- Initial changelog entry. This is the first versioned release. Next releases will include a detailed overview of all the major changes introduced since the last version.

