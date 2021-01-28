locals {
  oidc_provider_url = split("https://", module.eks.cluster_oidc_issuer_url)[1]
  domain            = "${var.subdomain}.${var.route53_zone_name}"
}
