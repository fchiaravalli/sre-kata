provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

data "aws_caller_identity" "current" {}

data "terraform_remote_state" "network"{
  backend = "s3"

  config = {
    bucket = "tp-terraform-state-${data.aws_caller_identity.current.account_id}"
    key = "${var.aws_region}/${var.environment}/network/terraform.tfstate"
    region = var.aws_region
  }
}

data "aws_ami" "ecs_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.aws_ami]
    #amzn-ami-*-amazon-ecs-optimized
    #amzn2-ami-ecs-*-ebs
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}

locals {
  aws = var.aws_region != "cn-north-1" ? "aws" : "aws-cn"
  com = var.aws_region != "cn-north-1" ? "com" : "com.cn"
  key = var.aws_region != "cn-north-1" ? var.aws-key-fake : var.aws-key
}

module "ecs_instances" {
  source = "../ecs_instances"

  aws_region              = var.aws_region
  environment             = var.environment
  cluster                 = "${var.cluster}-${var.environment}"
  instance_group          = var.instance_group
  private_subnet_ids      = data.terraform_remote_state.network.outputs.private_subnet_ids
  aws_ami                 = data.aws_ami.ecs_ami.id
  instance_type           = var.instance_type
  max_size                = var.max_size
  min_size                = var.min_size
  desired_capacity        = var.desired_capacity
  vpc_id                  = data.terraform_remote_state.network.outputs.vpc_id
  iam_instance_profile_id = aws_iam_instance_profile.ecs.id
  key_name                = aws_key_pair.ecs.key_name
  load_balancers          = var.load_balancers
  depends_id              = data.terraform_remote_state.network.outputs.depends_id
  custom_userdata         = var.custom_userdata
  cloudwatch_prefix       = "${var.cloudwatch_prefix}-${var.environment}"
  additional_sg           = [
    
  ]

  local_aws = local.aws
  local_com = local.com
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.cluster}-${var.environment}"
  tags = {
    Name = "nozapp-${var.aws_region}-${var.environment}",
    Environment = var.environment
  }
}

resource "aws_key_pair" "ecs" {
  key_name   = "ecs-key-${var.environment}"
  public_key = local.key
}


