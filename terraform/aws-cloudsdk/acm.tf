resource "aws_acm_certificate" "cloudsdk" {
  domain_name               = local.domain
  subject_alternative_names = ["*.${local.domain}"]
  validation_method         = "DNS"
  tags                      = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cloudsdk_ssl_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cloudsdk.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id         = data.aws_route53_zone.cloudsdk.zone_id
  name            = each.value.name
  type            = each.value.type
  ttl             = 600
  allow_overwrite = true
  records = [
    each.value.record
  ]
}
