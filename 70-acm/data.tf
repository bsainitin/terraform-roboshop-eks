data "aws_route53_zone" "hosted_zone" {
  name         = "theawsdevops.space"
  private_zone = false
}