variable "project_name" {}

variable "subnet_ids" {
  type = "list"
}

variable "sg_ids" {
  type = "list"
}

variable "storage_gb" {}
variable "storage_type" {}
variable "engine" {}
variable "engine_version" {}
variable "class" {}
variable "name" {}
variable "username" {}
variable "password" {}
