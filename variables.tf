#------------------------------------------------------------------------------
# General Configuration
#------------------------------------------------------------------------------

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
  validation {
    condition     = can(lookup(var.tags, "Project", null))
    error_message = "Tags must include a 'Project' key for resource naming"
  }
}

#------------------------------------------------------------------------------
# VPC Configuration
#------------------------------------------------------------------------------

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  validation {
    condition     = can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", var.vpc_cidr))
    error_message = "The vpc_cidr value must be a valid CIDR block"
  }
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

#------------------------------------------------------------------------------
# Subnet Configuration
#------------------------------------------------------------------------------

variable "availability_zones" {
  description = "List of availability zones for subnet placement"
  type        = list(string)
  validation {
    condition     = length(var.availability_zones) > 0
    error_message = "At least one availability zone must be specified"
  }
}

variable "subnet_bits" {
  description = "Number of additional bits with which to extend the VPC CIDR prefix for subnet calculations"
  type        = number
  default     = 8
  validation {
    condition     = var.subnet_bits >= 1 && var.subnet_bits <= 16
    error_message = "Subnet bits must be between 1 and 16"
  }
}

variable "create_public_subnets" {
  description = "Whether to create public subnets"
  type        = bool
  default     = true
}

#------------------------------------------------------------------------------
# CIDR Configuration
#------------------------------------------------------------------------------

variable "secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks to associate with the VPC"
  type        = list(string)
  default     = []
  validation {
    condition     = alltrue([for cidr in var.secondary_cidr_blocks : can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", cidr))])
    error_message = "All secondary CIDR blocks must be valid CIDR notation"
  }
}

#------------------------------------------------------------------------------
# Resource Naming
#------------------------------------------------------------------------------

variable "name_prefix" {
  description = "Prefix to be used for resource names"
  type        = string
  default     = ""
  validation {
    condition     = length(var.name_prefix) <= 20
    error_message = "The name_prefix value must not exceed 20 characters"
  }
}

#------------------------------------------------------------------------------
# Route Table Configuration
#------------------------------------------------------------------------------

variable "route_table_tags" {
  description = "Additional tags for the route tables"
  type        = map(string)
  default     = {}
}
