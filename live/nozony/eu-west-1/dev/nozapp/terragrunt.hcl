inputs = {
  appname = "nozapp"
  appversion = "0.1"
  builddir = "/home/fabrizio/Documents/nozapp/sre-kata/pywebapp"
  max_capacity = "8"
}

dependencies {
  paths = ["../ecs"]
}

terraform {
  source = "../../../../../modules//ecr"
}

include {
  path = "${find_in_parent_folders()}"
}
