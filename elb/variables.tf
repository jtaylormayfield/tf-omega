variable "project_name" {}

variable "security_groups" {
  type = "list"
}

variable "subnets" {
  type = "list"
}

variable "log_bucket" {}
variable "log_bucket_prefix" {}
variable "log_interval" {}
variable "instance_port" {}
variable "instance_protocol" {}
variable "lb_port" {}
variable "lb_protocol" {}
variable "healthy_checks" {}
variable "unhealthy_checks" {}
variable "timeout" {}
variable "interval" {}
