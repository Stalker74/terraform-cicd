output "vpc_id" {
  value = module.vpc.vpc_id
}

output "web_instance_id" {
  value = module.ec2.instance_id
}

output "web_public_ip" {
  value = module.ec2.public_ip
}

output "web_url" {
  value = "http://${module.ec2.public_ip}"
}

output "artifacts_bucket" {
  value = module.s3.artifacts_bucket_id
}

output "logs_bucket" {
  value = module.s3.logs_bucket_id
}

output "cloudwatch_log_group" {
  value = module.cloudwatch.log_group_name
}
