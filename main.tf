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

# module "compute"{}

