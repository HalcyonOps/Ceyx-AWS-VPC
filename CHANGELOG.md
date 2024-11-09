# Changelog

All notable changes to this module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2024-04-27
### Added
- Support for multiple NAT Gateways across Availability Zones.
- Integration with AWS Transit Gateway.

### Changed
- Updated default VPC CIDR block to `10.0.0.0/16`.

## [1.1.0] - 2024-03-15
### Added
- Enabled VPC Flow Logs by default.
- Added support for custom Route Tables.

### Changed
- Enhanced subnet tagging for better resource identification.

## [1.0.0] - 2024-01-10
### Added
- Initial release with basic VPC setup, public/private subnets, Internet and NAT Gateways, and Flow Logs.
