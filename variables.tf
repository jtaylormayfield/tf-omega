# General
variable "project_name" {}

variable "aws_access_key" {}
variable "aws_secret_key" {}

# Networking
variable "cidr" {}
variable "private_block" {}
variable "public_block" {}
variable "private_subnets" {}
variable "public_subnets" {}

# Compute
variable instance_type {}
variable public_key_path {}
