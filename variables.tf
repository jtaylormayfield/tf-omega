# General

variable "project_name" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "cloudflare_email" {}
variable "cloudflare_token" {}

# Networking

variable "cidr" {}
variable "private_block" {}
variable "public_block" {}
variable "private_subnets" {}
variable "public_subnets" {}

# Compute

variable "instance_type" {}
variable "public_key_path" {}
variable "max_instances" {}
variable "min_instances" {}
variable "instance_health_check_grace_seconds" {}
variable "wait_for_instance_capacity" {}

# RDS

variable "rds_storage_gb" {}
variable "rds_storage_type" {}
variable "rds_engine" {}
variable "rds_engine_version" {}
variable "rds_class" {}
variable "rds_db_name" {}
variable "rds_username" {}
variable "rds_password" {}

# Lambda

variable "lambda_bucket" {}
variable "email_lambda_path" {}
variable "email_lambda_version" {}
variable "email_lambda_handler" {}
variable "email_lambda_runtime" {}
variable "email_username" {}
variable "email_password" {}
variable "email_smtp_host" {}
variable "email_smtp_port" {}
variable "email_from" {}
variable "email_to" {}

# ELB

variable "lb_log_bucket_prefix" {}
variable "lb_log_interval" {}
variable "lb_port" {}
variable "lb_protocol" {}
variable "lb_num_healthy_checks" {}
variable "lb_num_unhealthy_checks" {}
variable "lb_timeout" {}
variable "lb_interval" {}

# Route53

variable "domain_name" {}
