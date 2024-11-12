locals {
  # Core settings
  region = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id
  
  # Project naming
  project_prefix = coalesce(try(var.tags["Project"], ""), "default")
  environment    = coalesce(try(var.tags["Environment"], ""), "default")
  
  # VPC naming conventions
  vpc_name = "${local.project_prefix}-vpc"
  
  # Subnet calculations
  availability_zone_count = length(var.availability_zones)
  
  # Subnet naming
  public_subnet_names = [
    for idx in range(local.availability_zone_count) : 
    "${local.project_prefix}-public-subnet-${idx + 1}"
  ]
  
  private_subnet_names = [
    for idx in range(local.availability_zone_count) : 
    "${local.project_prefix}-private-subnet-${idx + 1}"
  ]

  # Route table naming
  public_route_table_name  = "${local.project_prefix}-public-rt"
  private_route_table_names = [
    for idx in range(local.availability_zone_count) : 
    "${local.project_prefix}-private-rt-${idx + 1}"
  ]

  # Common tags that should be applied to all resources
  common_tags = {
    Project     = local.project_prefix
    Environment = local.environment
    Region      = local.region
    ManagedBy   = "terraform"
    Module      = "vpc"
  }

  # Resource tags with optional user-provided tags merged in
  resource_tags = merge(
    local.common_tags,
    var.tags
  )

  # Network specific tags
  network_tags = merge(
    local.resource_tags,
    {
      NetworkTier = "vpc"
    }
  )
}
