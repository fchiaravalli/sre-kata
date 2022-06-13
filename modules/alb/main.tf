# Default ALB implementation that can be used connect ECS instances to it

resource "aws_alb" "alb" {
  name            = var.alb_name
  internal = false
  subnets         = var.public_subnet_ids
  security_groups = [aws_security_group.alb.id]
  idle_timeout = var.idle_timeout
  enable_deletion_protection = true

  tags = {
    Environment = "HTTP alb for ${var.environment}"
  }
}

resource "aws_security_group" "alb" {
  description = "sg for ${var.alb_name} ALB in ${var.environment}"
  vpc_id = var.vpc_id

  tags = {
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "http_from_anywhere" {
  type              = "ingress"
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = "TCP"
  cidr_blocks       = [var.allow_cidr_block]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "outbound_internet_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

