provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-2"
}

module "storage" {
  source       = "./storage"
  project_name = "${var.project_name}"
}

module "networking" {
  source              = "./networking"
  project_name        = "${var.project_name}"
  vpc_cidr            = "${var.cidr}"
  rt_private_cidr     = "${var.private_block}"
  rt_public_cidr      = "${var.public_block}"
  num_private_subnets = "${var.private_subnets}"
  num_public_subnets  = "${var.public_subnets}"
}

module "compute" {
  source          = "./compute"
  project_name    = "${var.project_name}"
  instance_type   = "${var.instance_type}"
  default_sg_id   = "${module.networking.default_sg_id}"
  public_key_path = "${var.public_key_path}"
  subnet          = "${module.networking.public_subnet_ids[0]}"
}

module "rds" {
  source         = "./rds"
  project_name   = "${var.project_name}"
  subnet_ids     = ["${module.networking.private_subnet_ids}"]
  sg_ids         = ["${module.networking.db_sg_id}"]
  storage_gb     = "${var.rds_storage_gb}"
  storage_type   = "${var.rds_storage_type}"
  engine         = "${var.rds_engine}"
  engine_version = "${var.rds_engine_version}"
  class          = "${var.rds_class}"
  name           = "${var.rds_db_name}"
  username       = "${var.rds_username}"
  password       = "${var.rds_password}"
}

module "sns" {
  source           = "./sns"
  billing_lambda   = "${module.lambda.email_lambda_arn}"
  autoscale_lambda = "${module.lambda.email_lambda_arn}"
}

module "lambda" {
  source          = "./lambda"
  email_bucket    = "${var.lambda_bucket}"
  email_path      = "${var.email_lambda_path}"
  email_version   = "${var.email_lambda_version}"
  email_handler   = "${var.email_lambda_handler}"
  email_runtime   = "${var.email_lambda_runtime}"
  email_username  = "${var.email_username}"
  email_password  = "${var.email_password}"
  email_smtp_host = "${var.email_smtp_host}"
  email_smtp_port = "${var.email_smtp_port}"
  email_from      = "${var.email_from}"
  email_to        = "${var.email_to}"
}
