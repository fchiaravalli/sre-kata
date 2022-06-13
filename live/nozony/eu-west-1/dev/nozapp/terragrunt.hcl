inputs = {
  appname = "nozapp"
  appversion = "0.1"
  builddir = "/home/fabrizio/Documents/nozony/pywebapp"
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
