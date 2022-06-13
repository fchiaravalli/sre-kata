terraform {
  source = "../../../../../modules//ecs"
}

include {
  path = "${find_in_parent_folders()}"
}

dependencies {
  paths = ["../network"]
}

inputs = {
  max_size = 1
  min_size = 1
  desired_capacity = 1
  instance_type = "t2.micro"
  cluster = "nozapp"
  cloudwatch_prefix = "nozapp"
}