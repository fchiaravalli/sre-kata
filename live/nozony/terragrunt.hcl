remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "tp-terraform-state-${get_aws_account_id()}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks"

    s3_bucket_tags = {
      owner = "terragrunt integration test"
      name  = "Terraform state storage"
    }

    dynamodb_table_tags = {
      owner = "terragrunt integration test"
      name  = "Terraform lock table"
    }
  }
}

locals {
  default_yaml_path = find_in_parent_folders("empty.yaml")
}

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
# Configure Terragrunt to use common vars encoded as yaml to help you keep often-repeated variables (e.g., account ID)
# DRY. We use yamldecode to merge the maps into the inputs, as opposed to using varfiles due to a restriction in
# Terraform >=0.12 that all vars must be defined as variable blocks in modules. Terragrunt inputs are not affected by
# this restriction.
yamldecode(
file("${find_in_parent_folders("region.yaml", local.default_yaml_path)}")
#file("${get_terragrunt_dir()}/${find_in_parent_folders("region.yaml", local.default_yaml_path)}"),
),
yamldecode(
file("${find_in_parent_folders("env.yaml", local.default_yaml_path)}"),
),
#yamldecode(
#file("${find_in_parent_folders("account.yaml", local.default_yaml_path)}"),
#),
)
