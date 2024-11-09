# VPC Module

A Terraform module to provision an AWS VPC with public and private subnets, Internet Gateway, NAT Gateway, Route Tables, and Flow Logs, adhering to security best practices and organizational standards.

## Overview

This module creates a VPC with:
- Public and private subnets across specified Availability Zones
- Internet Gateway for public subnets
- NAT Gateway for enabling outbound internet access from private subnets
- Route Tables and associations
- VPC Flow Logs for monitoring network traffic

## Usage

```hcl
module "vpc" {
  source = "./modules/network/vpc"

  vpc_cidr                = "10.0.0.0/16"
  public_subnets          = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets         = ["10.0.101.0/24", "10.0.102.0/24"]
  azs                     = ["us-east-1a", "us-east-1b"]
  tags = {
    Environment = "production"
    Project     = "ceyx"
    Owner       = "YourName"
  }
}
```

## Inputs

| Name                            | Description                                                      | Type           | Default                          | Required |
| ------------------------------- | ---------------------------------------------------------------- | -------------- | -------------------------------- | -------- |
| `vpc_cidr`                      | The CIDR block for the VPC.                                      | `string`       | `"10.0.0.0/16"`                  | no       |
| `public_subnets`                | List of public subnet CIDRs.                                     | `list(string)` | `["10.0.1.0/24", "10.0.2.0/24"]` | no       |
| `private_subnets`               | List of private subnet CIDRs.                                    | `list(string)` | `["10.0.101.0/24", "10.0.102.0/24"]` | no    |
| `azs`                           | List of Availability Zones.                                      | `list(string)` | `["us-east-1a", "us-east-1b"]`    | no       |
| `tags`                          | Tags to apply to all resources.                                  | `map(string)`  | See default in `variables.tf`     | no       |
| `enable_nat_gateway`            | Enable NAT Gateway for private subnets.                          | `bool`         | `true`                            | no       |
| `single_nat_gateway`            | Use a single NAT Gateway for all public subnets.                 | `bool`         | `true`                            | no       |
| `enable_vpc_flow_log`           | Enable VPC Flow Logs.                                            | `bool`         | `true`                            | no       |
| `flow_log_retention_days`       | Number of days to retain VPC Flow Logs.                          | `number`       | `30`                              | no       |
| `flow_log_aggregation_interval` | Maximum interval of aggregating flow log records, in seconds.    | `number`       | `60`                              | no       |

## Outputs

| Name                  | Description                                  |
| --------------------- | -------------------------------------------- |
| `vpc_id`              | The ID of the VPC.                           |
| `public_subnet_ids`   | List of public subnet IDs.                   |
| `private_subnet_ids`  | List of private subnet IDs.                  |
| `internet_gateway_id` | The ID of the Internet Gateway.              |
| `nat_gateway_id`      | The ID of the NAT Gateway.                   |
| `flow_log_group_id`   | The ID of the Flow Log CloudWatch Log Group. |
| `flow_log_role_arn`   | The ARN of the IAM role for Flow Logs.       |

## Requirements

- Terraform >= 1.5.0
- AWS Provider >= 5.0.0

## Versioning and Release Management

- **Semantic Versioning:** MAJOR.MINOR.PATCH
- **Changelog:** Maintain a [`CHANGELOG.md`](CHANGELOG.md) documenting changes for each release.
- **Release Process:** Develop features/fixes, conduct code reviews, testing, update version, update changelog, tag release, and publish.

*Reference:* [Terraform Module Versioning Best Practices](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## License

This project is licensed under the [Apache License 2.0](../../LICENSE).

## References

- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/index.html)
- [Terraform AWS VPC Module Example](https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/examples/complete/main.tf)
- [Terraform Best Practices](https://www.terraform.io/language/best-practices)
- [AWS Well-Architected Framework – Security Pillar](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)

---
