plugin "aws" {
  enabled = true
  version = "0.34.1"
}

config {
  aws_region = var.azs[0]
}
