variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  validation {
    condition     = can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", var.vpc_cidr))
    error_message = "vpc_cidr must be a valid CIDR notation (e.g., 10.0.0.0/16)."
  }
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
  validation {
    condition     = length(var.public_subnets) > 0
    error_message = "At least one public subnet CIDR block must be provided."
  }
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
  validation {
    condition     = length(var.private_subnets) > 0
    error_message = "At least one private subnet CIDR block must be provided."
  }
}

variable "azs" {
  description = "List of Availability Zones."
  type        = list(string)
  validation {
    condition     = length(var.azs) >= 1
    error_message = "At least one Availability Zone must be specified."
  }
}

variable "region" {
  description = "The region to deploy the VPC in."
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)

  validation {
    condition = (
      contains(keys(var.tags), "Environment") &&
      contains(keys(var.tags), "Owner") &&
      contains(keys(var.tags), "Project")
    )
    error_message = "Tags must include Environment, Owner, and Project."
  }
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all private subnets."
  type        = bool
  default     = true
}
