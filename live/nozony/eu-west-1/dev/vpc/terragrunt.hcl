inputs = {
  cidr = "10.1.0.0/16"
}

terraform {
  source = "../../../../../modules//vpc"
}

include {
  path = "${find_in_parent_folders()}"
}


