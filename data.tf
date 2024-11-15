# Get current AWS region
data "aws_region" "current" {}

# Get available AZs in the current region
data "aws_availability_zones" "available" {
  state = "available"
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}
