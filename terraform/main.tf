terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
}

module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
  environment  = var.environment
}

module "iam" {
  source               = "./modules/iam"
  project_name         = var.project_name
  environment          = var.environment
  artifacts_bucket_arn = module.s3.artifacts_bucket_arn
  logs_bucket_arn      = module.s3.logs_bucket_arn
}

module "cloudwatch" {
  source       = "./modules/cloudwatch"
  project_name = var.project_name
  environment  = var.environment
}

module "ec2" {
  source                = "./modules/ec2"
  project_name          = var.project_name
  environment           = var.environment
  instance_type         = var.instance_type
  subnet_id             = module.vpc.public_subnet_id
  security_group_id     = module.vpc.web_sg_id
  instance_profile_name = module.iam.instance_profile_name
  log_group_name        = module.cloudwatch.log_group_name
  log_stream_name       = module.cloudwatch.log_stream_name
  artifacts_bucket_id   = module.s3.artifacts_bucket_id
  logs_bucket_id        = module.s3.logs_bucket_id
}
