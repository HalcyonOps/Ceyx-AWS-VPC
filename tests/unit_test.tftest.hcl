# Unit Test for VPC Module

variables {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

run "validate_vpc_cidr" {
  command = plan

  assert {
    condition     = aws_vpc.this.cidr_block == var.cidr_block
    error_message = "VPC CIDR block does not match the expected value."
  }

  assert {
    condition     = aws_vpc.this.enable_dns_support == var.enable_dns_support
    error_message = "DNS support is not enabled on the VPC."
  }

  assert {
    condition     = aws_vpc.this.enable_dns_hostnames == var.enable_dns_hostnames
    error_message = "DNS hostnames are not enabled on the VPC."
  }
}
