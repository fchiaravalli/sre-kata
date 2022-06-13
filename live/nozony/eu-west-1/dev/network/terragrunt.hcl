terraform {
  source = "../../../../../modules//network"
}

include {
  path = "${find_in_parent_folders()}"
}

dependencies {
  paths = ["../vpc"]
}

inputs = {
  public_subnet_cidrs = [
    "10.1.0.0/24",
    "10.1.1.0/24"]
  private_subnet_cidrs = [
    "10.1.50.0/24",
    "10.1.51.0/24"]
  depends_id = ""
}