provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

data "aws_caller_identity" "current" {}

data "terraform_remote_state" "vpc"{
  backend = "s3"

  config = {
    bucket = "tp-terraform-state-${data.aws_caller_identity.current.account_id}"
    key = "${var.aws_region}/${var.environment}/vpc/terraform.tfstate"
    region = var.aws_region
  }
}

module "private_subnet" {
  source = "../subnet"

  name               = "${var.environment}_private_subnet"
  environment        = var.environment
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  cidrs              = var.private_subnet_cidrs
  availability_zones = var.availability_zones

}

module "public_subnet" {
  source = "../subnet"

  name               = "${var.environment}_public_subnet"
  environment        = var.environment
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  cidrs              = var.public_subnet_cidrs
  availability_zones = var.availability_zones
}

module "nat" {
  source = "../nat_gateway"

  subnet_ids   = module.public_subnet.ids
  subnet_count = length(var.public_subnet_cidrs)
  environment = var.environment
}

resource "aws_route" "public_igw_route" {
  count                  = length(var.public_subnet_cidrs)
  route_table_id         = element(module.public_subnet.route_table_ids, count.index)
  gateway_id             = data.terraform_remote_state.vpc.outputs.igw
  destination_cidr_block = var.destination_cidr_block
}

resource "aws_route" "private_nat_route" {
  count                  = length(var.private_subnet_cidrs)
  route_table_id         = element(module.private_subnet.route_table_ids, count.index)
  nat_gateway_id         = element(module.nat.ids, count.index)
  destination_cidr_block = var.destination_cidr_block
}

# Creating a NAT Gateway takes some time. Some services need the internet (NAT Gateway) before proceeding. 
# Therefore we need a way to depend on the NAT Gateway in Terraform and wait until is finished. 
# Currently Terraform does not allow module dependency to wait on.
# Therefore we use a workaround described here: https://github.com/hashicorp/terraform/issues/1178#issuecomment-207369534

resource "null_resource" "dummy_dependency" {
  depends_on = [module.nat]
}

#data "aws_vpc_endpoint_service" "s3" {
#  service = "s3"
#  service_type = "Gateway"
#}

#resource "aws_vpc_endpoint" "s3" {
#  vpc_id       = data.terraform_remote_state.vpc.outputs.vpc_id
#  service_name = data.aws_vpc_endpoint_service.s3.service_name
##  vpc_endpoint_type = "Gateway"
#}

#resource "aws_vpc_endpoint_route_table_association" "private_s3" {
#  count                  = length(var.private_subnet_cidrs)

# vpc_endpoint_id = aws_vpc_endpoint.s3.id
#  route_table_id  = element(module.private_subnet.route_table_ids, count.index)
#}

#data "aws_vpc_endpoint_service" "dynamodb" {
#  service = "dynamodb"
#}

#resource "aws_vpc_endpoint" "dynamodb" {
#  vpc_id       = data.terraform_remote_state.vpc.outputs.vpc_id
#  service_name = data.aws_vpc_endpoint_service.dynamodb.service_name
#}

#resource "aws_vpc_endpoint_route_table_association" "private_dynamodb" {
#  count                  = length(var.private_subnet_cidrs)

#  vpc_endpoint_id = aws_vpc_endpoint.dynamodb.id
#  route_table_id  = element(module.private_subnet.route_table_ids, count.index)
#}

#data "aws_vpc_endpoint_service" "kinesis" {
#  service = "kinesis-streams"
#}

#resource "aws_vpc_endpoint" "kinesis" {
#  vpc_id       = data.terraform_remote_state.vpc.outputs.vpc_id
#  service_name = data.aws_vpc_endpoint_service.kinesis.service_name
#  vpc_endpoint_type = "Interface"
#  security_group_ids = [aws_security_group.vpc_endpoints.id]
#  subnet_ids = module.private_subnet.ids
#  private_dns_enabled = true
#}

data "aws_vpc_endpoint_service" "logs" {
  service = "logs"
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id       = data.terraform_remote_state.vpc.outputs.vpc_id
  service_name = data.aws_vpc_endpoint_service.logs.service_name
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.vpc_endpoints.id]
  subnet_ids = module.private_subnet.ids
  private_dns_enabled = true
}

resource "aws_security_group" "vpc_endpoints" {
  description = "sg for VPC endpoints in ${var.environment}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_security_group_rule" "access_from_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = var.private_subnet_cidrs
  security_group_id = aws_security_group.vpc_endpoints.id
}