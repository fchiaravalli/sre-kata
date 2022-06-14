variable "aws_region" {
  description = "AWS region to use"
}

variable "environment" {
  description = "The name of the environment"
}

variable "appname" {
}

variable "appversion" {
  description = "Version of the app"
}

variable "env_vars" {
  type = list(map(string))
  default = [{}]
}

variable "builddir" {
  description = "Dir where to put python code and dockerfile"
}

variable "cpu" {
  description = "CPU for container"
  default = 10
}

variable "memory" {
  description = "memroy for container"
  default = 256
}

variable "app_port" {
  default = 8080
}

variable "max_capacity" {
  default = 4
}

variable "min_capacity" {
  default = 1
}