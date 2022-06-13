provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true

  tags = {
    Name        = var.environment
    Environment = var.environment
    Region      = var.aws_region
  }
}

resource "aws_internet_gateway" "vpc" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Environment = var.environment
    Region      = var.aws_region
  }
}
