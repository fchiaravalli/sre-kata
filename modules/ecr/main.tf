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

data "terraform_remote_state" "ecs"{
  backend = "s3"

  config = {
    bucket = "tp-terraform-state-${data.aws_caller_identity.current.account_id}"
    key = "${var.aws_region}/${var.environment}/ecs/terraform.tfstate"
    region = var.aws_region
  }
}

resource "aws_ecr_repository" "repo" {
  name = var.appname
}

resource "null_resource" "dockerimage" {
  triggers = {
    always_run = "${timestamp()}"
  }
  depends_on = [
    aws_ecr_repository.repo
     ]
  provisioner local-exec { 
    command = <<-EOT
     cd ${var.builddir}
     docker build . -t ${aws_ecr_repository.repo.repository_url}:${var.appversion}
     aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com
     docker push ${aws_ecr_repository.repo.repository_url}:${var.appversion}
    EOT
  }
} 

resource "aws_ecs_task_definition" "aws-ecs-task" {
  family = "${var.appname}-task"
  container_definitions = jsonencode([
    {
      name      = "${var.appname}-${var.environment}-container"
      image     = "${aws_ecr_repository.repo.repository_url}:${var.appversion}"
      cpu       = var.cpu
      memory    = var.memory
      essential = true
      portMappings = [
        {
          containerPort = var.app_port
          hostPort      = var.app_port
        }
      ]
    }
    ])
  depends_on = [
    null_resource.dockerimage
     ]
  #network_mode = "awsvpc"
  #execution_role_arn       = data.terraform_remote_state.ecs.outputs.ecs_task_role 
  #task_role_arn            = data.terraform_remote_state.ecs.outputs.ecs_task_role 
}

resource "aws_ecs_service" "aws-ecs-service" {
  name                 = "${var.appname}-${var.environment}-ecs-service"
  cluster              = data.terraform_remote_state.ecs.outputs.cluster_id 
  task_definition      = aws_ecs_task_definition.aws-ecs-task.arn #"${aws_ecs_task_definition.aws-ecs-task.family}:${max(aws_ecs_task_definition.aws-ecs-task.revision, data.aws_ecs_task_definition.main.revision)}"
  launch_type          = "EC2"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true

  #network_configuration {
  #  subnets          = data.terraform_remote_state.network.outputs.private_subnet_ids
  #  assign_public_ip = false
  #  security_groups = [
  #    aws_security_group.service_security_group.id,
  #    aws_security_group.load_balancer_security_group.id
  #  ]
 # }

  load_balancer {
    target_group_arn = data.terraform_remote_state.ecs.outputs.aws_target_group
    container_name   = "${var.appname}-${var.environment}-container"
    container_port   = 8080
  }

}

