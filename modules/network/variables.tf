variable "environment" {
  description = "The name of the environment"
}

variable "destination_cidr_block" {
  default     = "0.0.0.0/0"
  description = "Specify all traffic to be routed either trough Internet Gateway or NAT to access the internet"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of private cidrs, for every avalibility zone you want you need one. Example: 10.0.0.0/24 and 10.0.1.0/24"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of public cidrs, for every avalibility zone you want you need one. Example: 10.0.0.0/24 and 10.0.1.0/24"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of avalibility zones you want. Example: eu-west-1a and eu-west-1b"
}

variable "depends_id" {}


variable "aws_region" {
  description = "AWS region to use"
}

