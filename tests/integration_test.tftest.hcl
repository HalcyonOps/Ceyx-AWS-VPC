# Integration Test for VPC Module

variables {
  cidr_block           = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
}

run "deploy_vpc_and_subnets" {
  command = apply

  assert {
    condition     = aws_vpc.this.id != ""
    error_message = "VPC was not created successfully."
  }

  assert {
    condition     = length(aws_subnet.public) == length(var.public_subnet_cidrs)
    error_message = "Number of public subnets does not match the expected count."
  }

  assert {
    condition     = length(aws_subnet.private) == length(var.private_subnet_cidrs)
    error_message = "Number of private subnets does not match the expected count."
  }

  assert {
    condition     = aws_vpc.this.tags["Name"] == "production-vpc"
    error_message = "VPC does not have the correct Name tag."
  }

  assert {
    condition     = aws_internet_gateway.this.id != ""
    error_message = "Internet Gateway was not created successfully."
  }

  assert {
    condition     = aws_route_table.public.route[0].gateway_id == aws_internet_gateway.this.id
    error_message = "Public Route Table is not correctly associated with the Internet Gateway."
  }
}
