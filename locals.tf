locals {
  region         = var.region
  project_prefix = "${lookup(var.tags, "Project", "default-project")}-"

  private_subnet_names = [
    for idx, subnet in var.private_subnets : "${local.project_prefix}private-subnet-${idx + 1}"
  ]

  # Centralized resource tags
  resource_tags = merge(
    var.tags,
    {
      Project     = var.tags["Project"]
      Environment = var.tags["Environment"]
      Owner       = var.tags["Owner"]
    }
  )
}
