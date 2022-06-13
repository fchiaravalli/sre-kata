variable "environment" {
  description = "The name of the environment"
}

variable "cluster" {
  default     = "ecs"
  description = "The name of the ECS cluster"
}

variable "instance_group" {
  default     = "ecs"
  description = "The name of the instances that you consider as a group"
}

variable "load_balancers" {
  type        = list(string)
  default     = []
  description = "The load balancers to couple to the instances"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of avalibility zones you want. Example: eu-west-1a and eu-west-1b"
}

variable "max_size" {
  description = "Maximum size of the nodes in the cluster"
}

variable "min_size" {
  description = "Minimum size of the nodes in the cluster"
}

variable "desired_capacity" {
  description = "The desired capacity of the cluster"
}

variable "instance_type" {
  description = "AWS instance type to use"
}

variable "custom_userdata" {
  default     = ""
  description = "Inject extra command in the instance template to be run on boot"
}

variable "ecs_config" {
  default     = "echo '' > /etc/ecs/ecs.config"
  description = "Specify ecs configuration or get it from S3. Example: aws s3 cp s3://some-bucket/ecs.config /etc/ecs/ecs.config"
}

variable "ecs_logging" {
  default     = "[\"json-file\",\"awslogs\"]"
  description = "Adding logging option to ECS that the Docker containers can use. It is possible to add fluentd as well"
}

variable "cloudwatch_prefix" {
  default     = ""
  description = "If you want to avoid cloudwatch collision or you don't want to merge all logs to one log group specify a prefix"
}

variable "aws_region" {
  description = "AWS region to use"
}

variable "scale_up_cooldown_seconds" {
  default = "300"
}

variable "scale_down_cooldown_seconds" {
  default = "300"
}

variable "high_cpu_evaluation_periods" {
  default = "2"
}

variable "high_cpu_period_seconds" {
  default = "300"
}

variable "high_cpu_threshold_percent" {
  default = "90"
}

variable "low_cpu_evaluation_periods" {
  default = "2"
}

variable "low_cpu_period_seconds" {
  default = "300"
}

variable "low_cpu_threshold_percent" {
  default = "10"
}

variable "high_memory_evaluation_periods" {
  default = "2"
}

variable "high_memory_period_seconds" {
  default = "300"
}

variable "high_memory_threshold_percent" {
  default = "75"
}

variable "low_memory_evaluation_periods" {
  default = "2"
}

variable "low_memory_period_seconds" {
  default = "300"
}

variable "low_memory_threshold_percent" {
  default = "50"
}

variable "aws_ami" {
  type = string
  default = "amzn-ami-*-amazon-ecs-optimized"
}
variable "aws-key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEAgHbckvbhCECjdCySFNEIOP6Yh6i8ABPTI/s3j9amxSlx09bFJKqCst6LlP8mrUx3AISsHUNsmAsjxrjH+9uXuA8vU4SvYytgYBWc6a+e5izaw+q0nB4VWCcHddPQEVW463gYHL+lZBHNQO4x8EWm59y0zO+xQd94mx67/qOllY0= rsa-key-20180718"
}
variable "aws-key-fake" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9LXkBtOJZ+84YG61InqOgnWg4ssofIyAXWI6BFFSorcJtwxw4x9+fqokBzLzhb4nOF+KOo4IJWh45XLVe+C+H5BQ/9ZBRjxjkJwrPiXZQg6ISEKt9of9ZSUCrhIzacsOBeNthjzAIDjbQCkfdGsbhsbqGIWTLPvSmZm3SgKx0RPfAG0NwMqHI9s5WXEYV8gvDHf8N21RN/c+PA6Y0hnnYY7O2grH4WEBdyWwMfWl9yCbQ7ar8SgHHofmestFnuDNh6YVJw5EvYLye9xCyxXY3OGUkpADAdC9ZobYvtbD9djo/qjgeokkohEgy50zn4IdPsrnFEX9FzYef7G2lXBdP Teporary ssh key"
}

variable "use_fleet" {
  type = bool
  default = false
}

variable "http_port" {
  default = "80"
}

variable "app_port" {
  default = "8080"
}