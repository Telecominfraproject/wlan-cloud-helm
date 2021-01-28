module "external_dns_cluster_role" {
  source           = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-assumable-role-with-oidc?ref=v3.7.0"
  role_name        = "${module.eks.cluster_id}-external-dns"
  provider_url     = local.oidc_provider_url
  role_policy_arns = [aws_iam_policy.external_dns.arn]
  create_role      = true
  tags             = var.tags
}

resource "aws_iam_policy" "external_dns" {
  name_prefix = "external-dns"
  description = "EKS external-dns policy for cluster ${var.name}"
  policy      = data.aws_iam_policy_document.external_dns.json
}

data "aws_iam_policy_document" "external_dns" {
  statement {
    sid = "GrantModifyAccessToDomains"

    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:route53:::hostedzone/${data.aws_route53_zone.cloudsdk.zone_id}",
    ]
  }

  statement {
    sid = "GrantListAccessToDomains"

    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
    ]

    effect = "Allow"

    resources = ["*"]
  }
}

data "aws_region" "current" {}

resource "helm_release" "external-dns" {
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = "4.5.5"
  namespace  = "kube-system"

  set {
    name  = "podAnnotations.iam\\.amazonaws\\.com/role"
    value = module.external_dns_cluster_role.this_iam_role_arn
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.external_dns_cluster_role.this_iam_role_arn
  }

  set {
    name  = "aws.region"
    value = data.aws_region.current.name
  }

  set {
    name  = "txtOwnerId"
    value = "/hostedzone/${data.aws_route53_zone.cloudsdk.zone_id}"
  }

  set {
    name  = "domainFilters"
    value = "{${var.route53_zone_name}}"
  }

  set {
    name  = "policy"
    value = "sync"
  }
}
