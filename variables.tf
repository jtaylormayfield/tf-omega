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
variable "instance_type" {}

variable "public_key_path" {}

# RDS
variable "rds_storage_gb" {}

variable "rds_storage_type" {}
variable "rds_engine" {}
variable "rds_engine_version" {}
variable "rds_class" {}
variable "rds_db_name" {}
variable "rds_username" {}
variable "rds_password" {}
