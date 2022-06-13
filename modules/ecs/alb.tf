module "alb" {
  source = "../alb"

  environment       = var.environment
  alb_name          = "${var.cluster}-${var.environment}"
  vpc_id            = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_ids = data.terraform_remote_state.network.outputs.public_subnet_ids
  redirect_path = "/app/index.html"
  http_port = var.http_port
  deregistration_delay = "60"
}

resource "aws_security_group_rule" "alb_to_ecs" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "TCP"
  source_security_group_id = module.alb.alb_security_group_id
  security_group_id        = module.ecs_instances.ecs_instance_security_group_id
}


#resource "aws_security_group_rule" "ecs_to_alb_internal" {
#  type                     = "ingress"
#  from_port                = local.internal_port
#  to_port                  = local.internal_port
#  protocol                 = "TCP"
#  security_group_id        = module.alb.alb_security_group_id
#  cidr_blocks = formatlist("%s/32", data.terraform_remote_state.network.outputs.nat_gw_public_ips)
#}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.cluster}-${var.environment}-tg"
  port        = var.app_port
  protocol    = "HTTP"
  #target_type = "ip"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
    port = "traffic-port"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = module.alb.alb_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}
