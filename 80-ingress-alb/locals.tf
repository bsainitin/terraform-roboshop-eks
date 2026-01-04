locals {
  common_name_suffix = "${var.project_name}-${var.environment}"
  public_subnet_ids  = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
  ingress_alb_sg_id  = data.aws_ssm_parameter.ingress_alb_sg_id.value
  ingress_alb_certificate_arn = data.aws_ssm_parameter.ingress_alb_certificate_arn.value
  hosted_zone_id = data.aws_route53_zone.hosted_zone.zone_id
  common_tags = {
    Project     = "roboshop"
    Environment = "dev"
    Terraform   = "true"
  }
}