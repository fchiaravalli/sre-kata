output "registryurl" {
  value = aws_ecr_repository.repo.repository_url
  }

output dns_app {
  value = data.terraform_remote_state.ecs.outputs.dns_app
}

