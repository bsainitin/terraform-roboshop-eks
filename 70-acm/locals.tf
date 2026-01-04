locals {
  common_name_suffix = "${var.project_name}-${var.environment}"
  hosted_zone_id = data.aws_route53_zone.hosted_zone.zone_id
  common_tags = {
    Project = "roboshop"
    Environment = "dev"
    Terraform = "true"
  }
}