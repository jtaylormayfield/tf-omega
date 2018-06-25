provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-2"
}

provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
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
  source                    = "./compute"
  project_name              = "${var.project_name}"
  instance_type             = "${var.instance_type}"
  default_sg_id             = "${module.networking.default_sg_id}"
  public_key_path           = "${var.public_key_path}"
  subnet_ids                = "${module.networking.public_subnet_ids}"
  max_elb_pool              = "${var.max_instances}"
  min_elb_pool              = "${var.min_instances}"
  health_check_grace_period = "${var.instance_health_check_grace_seconds}"
  load_balancers            = ["${module.elb.default_lb}"]
  wait_for_elb_capacity     = "${var.wait_for_instance_capacity}"
  autoscale_topic_arn       = "${module.sns.autoscale_arn}"
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

module "cloudwatch" {
  source          = "./cloudwatch"
  project_name    = "${var.project_name}"
  region_name     = "us-east-2"
  billing_sns_arn = "${module.sns.billing_arn}"
}

module "elb" {
  source            = "./elb"
  project_name      = "${var.project_name}"
  security_groups   = ["${module.networking.default_sg_id}"]
  subnets           = ["${module.networking.public_subnet_ids}"]
  log_bucket        = "${module.storage.bucket_id}"
  log_bucket_prefix = "${var.lb_log_bucket_prefix}"
  log_interval      = "${var.lb_log_interval}"
  instance_port     = "80"
  instance_protocol = "http"
  lb_port           = "${var.lb_port}"
  lb_protocol       = "${var.lb_protocol}"
  healthy_checks    = "${var.lb_num_healthy_checks}"
  unhealthy_checks  = "${var.lb_num_unhealthy_checks}"
  timeout           = "${var.lb_timeout}"
  interval          = "${var.lb_interval}"
}

module "dns" {
  source          = "./dns"
  domain          = "${var.domain_name}"
  name            = "${var.project_name}"
  default_lb_name = "${module.elb.public_dns}"
}
