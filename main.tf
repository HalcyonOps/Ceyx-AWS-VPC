resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.resource_tags,
    {
      Name = "${local.project_prefix}vpc"
    }
  )
}

resource "aws_internet_gateway" "this" {
  count = var.create_public_subnets ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.resource_tags,
    {
      Name = "${local.project_prefix}igw"
    }
  )
}

resource "aws_subnet" "public" {
  count             = var.create_public_subnets ? length(var.availability_zones) : 0
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.subnet_bits, count.index)
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    local.resource_tags,
    {
      Name = "${local.project_prefix}public-subnet-${count.index + 1}"
      Tier = "public"
    }
  )
}

resource "aws_subnet" "private" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.subnet_bits, count.index + length(var.availability_zones))
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    local.resource_tags,
    {
      Name = "${local.project_prefix}private-subnet-${count.index + 1}"
      Tier = "private"
    }
  )
}

resource "aws_route_table" "public" {
  count  = var.create_public_subnets ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.resource_tags,
    {
      Name = "${local.project_prefix}public-rt"
    }
  )
}

resource "aws_route_table" "private" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.resource_tags,
    {
      Name = "${local.project_prefix}private-rt-${count.index + 1}"
    }
  )
}
