output "cluster_id" {
  value = aws_ecs_cluster.cluster.id
}

output "ecs_instance_security_group_id" {
  value = module.ecs_instances.ecs_instance_security_group_id
}

output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "ecs_task_role" {
  value = aws_iam_role.ecs_instance_role.arn
}

output "dns_app" {
  value = module.alb.alb_host_name
}

output "aws_target_group" {
  value = aws_lb_target_group.target_group.arn
}

