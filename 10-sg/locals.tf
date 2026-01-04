locals {
  common_suffix_name = "${var.project_name}-${var.environment}"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}