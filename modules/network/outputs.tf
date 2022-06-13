output "vpc_id" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id
}

output "vpc_cidr" {
  value = data.terraform_remote_state.vpc.outputs.cidr_block
}

output "private_subnet_ids" {
  value = module.private_subnet.ids
}

output "public_subnet_ids" {
  value = module.public_subnet.ids
}

output "depends_id" {
  value = null_resource.dummy_dependency.id
}

output "private_subnet_cidrs" {
  value = var.private_subnet_cidrs
}

output "public_subnet_cidrs" {
  value = var.public_subnet_cidrs
}

output "nat_gw_public_ips" {
  value = module.nat.public_ips
}

output "vpc_sg" {
  value = aws_security_group.vpc_endpoints.id
}