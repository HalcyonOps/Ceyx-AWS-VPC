resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.resource_tags,
    {
      Name = "${local.project_prefix}vpc"
      TTL  = "2024-12-31"
    }
  )
}
resource "aws_default_security_group" "default_disabled" {
  vpc_id = aws_vpc.this.id

  revoke_rules_on_delete = true

  lifecycle {
    prevent_destroy = true
  }

  tags = local.resource_tags

  dynamic "ingress" {
    for_each = []
    content {}
  }

  dynamic "egress" {
    for_each = []
    content {}
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.resource_tags,
    {
      Name = "${local.project_prefix}internet-gateway"
    }
  )
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index % length(var.azs)]
  map_public_ip_on_launch = false

  tags = merge(
    local.resource_tags,
    {
      Name = "${local.project_prefix}public-subnet-${count.index + 1}"
    }
  )
}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = var.azs[count.index % length(var.azs)]
  map_public_ip_on_launch = false

  tags = merge(
    local.resource_tags,
    {
      Name = local.private_subnet_names[count.index]
      Type = "private"
    }
  )
}

resource "aws_nat_gateway" "this" {
  count         = var.enable_nat_gateway && var.single_nat_gateway ? 1 : length(var.public_subnets)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    local.resource_tags,
    {
      Name = "${local.project_prefix}nat-gateway-${count.index + 1}"
    }
  )
}

resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway && var.single_nat_gateway ? 1 : length(var.public_subnets)
  domain = "vpc"

  tags = merge(
    local.resource_tags,
    {
      Name = "${local.project_prefix}nat-eip-${count.index + 1}"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${local.project_prefix}public-route-table"
    }
  )
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count = var.enable_nat_gateway && var.single_nat_gateway ? 1 : length(var.public_subnets)

  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[count.index].id
  }

  tags = merge(
    var.tags,
    {
      Name = "${local.project_prefix}private-route-table"
    }
  )
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_flow_log" "vpc_flow_logs" {
  vpc_id               = aws_vpc.this.id
  traffic_type         = "ALL"
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.flow_logs.arn
  iam_role_arn         = aws_iam_role.flow_logs_role.arn

  tags = merge(
    local.resource_tags,
    {
      Name = "${local.project_prefix}flow-logs"
    }
  )
}

resource "aws_iam_role" "flow_logs_role" {
  name = "${local.project_prefix}flow-logs-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = []
  })
  tags = merge(local.resource_tags, { Name = "${local.project_prefix}flow-logs-role" })
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  name              = "${local.project_prefix}flow-logs"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.flow_logs.arn

  tags = merge(
    local.resource_tags,
    {
      Name = "${local.project_prefix}flow-logs"
    }
  )
}

resource "aws_kms_key" "flow_logs" {
  description         = "KMS key for encrypting VPC Flow Logs"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.flow_logs_key_policy.json

  tags = merge(
    local.resource_tags,
    {
      Name = "${local.project_prefix}flow-logs-key"
    }
  )
}
