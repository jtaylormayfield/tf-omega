variable "project_name" {}
variable "instance_type" {}
variable "default_sg_id" {}
variable "public_key_path" {}

variable "subnet_ids" {
  type = "list"
}

variable "max_elb_pool" {}
variable "min_elb_pool" {}
variable "health_check_grace_period" {}

variable "load_balancers" {
  type = "list"
}

variable "wait_for_elb_capacity" {}
variable "autoscale_topic_arn" {}
