data "aws_route53_zone" "cloudsdk" {
  name = "${var.route53_zone_name}."
}
