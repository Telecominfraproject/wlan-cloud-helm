module "alb_ingress_iam_role" {
  source       = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-assumable-role-with-oidc?ref=v3.7.0"
  role_name    = "${module.eks.cluster_id}-alb-ingress"
  provider_url = local.oidc_provider_url
  role_policy_arns = [
    aws_iam_policy.alb_ingress_iam_policy.arn,
  ]
  create_role = true
  tags        = var.tags
}

resource "aws_iam_policy" "alb_ingress_iam_policy" {
  name_prefix = "alb-ingress-iam-policy-"
  description = "ALB ingress policy for cluster ${var.name}"
  policy      = data.aws_iam_policy_document.alb_ingress_iam_policy.json
}

data "aws_iam_policy_document" "alb_ingress_iam_policy" {
  statement {
    actions = [
      "iam:CreateServiceLinkedRole",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeVpcs",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeInstances",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeTags",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeListenerCertificates",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:DescribeTags"
    ]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
      "cognito-idp:DescribeUserPoolClient",
      "acm:ListCertificates",
      "acm:DescribeCertificate",
      "iam:ListServerCertificates",
      "iam:GetServerCertificate",
      "waf-regional:GetWebACL",
      "waf-regional:GetWebACLForResource",
      "waf-regional:AssociateWebACL",
      "waf-regional:DisassociateWebACL",
      "wafv2:GetWebACL",
      "wafv2:GetWebACLForResource",
      "wafv2:AssociateWebACL",
      "wafv2:DisassociateWebACL",
      "shield:GetSubscriptionState",
      "shield:DescribeProtection",
      "shield:CreateProtection",
      "shield:DeleteProtection"
    ]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupIngress"
    ]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
      "ec2:CreateSecurityGroup"
    ]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
      "ec2:CreateTags"
    ]
    effect    = "Allow"
    resources = ["arn:aws:ec2:*:*:security-group/*"]
    condition {
      test     = "StringEquals"
      values   = ["CreateSecurityGroup"]
      variable = "ec2:CreateAction"
    }

    condition {
      test     = "Null"
      values   = ["false"]
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
    }
  }

  statement {
    actions = [
      "ec2:CreateTags",
      "ec2:DeleteTags"
    ]
    effect    = "Allow"
    resources = ["arn:aws:ec2:*:*:security-group/*"]

    condition {
      test     = "Null"
      values   = ["true"]
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
    }

    condition {
      test     = "Null"
      values   = ["false"]
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
    }
  }

  statement {
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:DeleteSecurityGroup"
    ]
    effect    = "Allow"
    resources = ["arn:aws:ec2:*:*:security-group/*"]

    condition {
      test     = "Null"
      values   = ["false"]
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
    }
  }

  statement {
    actions = [
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateTargetGroup"
    ]
    effect    = "Allow"
    resources = ["*"]

    condition {
      test     = "Null"
      values   = ["false"]
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
    }
  }

  statement {
    actions = [
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:DeleteRule"
    ]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:RemoveTags"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
    ]
    condition {
      test     = "Null"
      values   = ["true"]
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
    }
    condition {
      test     = "Null"
      values   = ["false"]
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
    }
  }

  statement {
    actions = [
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:DeleteTargetGroup"
    ]
    effect    = "Allow"
    resources = ["*"]
    condition {
      test     = "Null"
      values   = ["false"]
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
    }
  }

  statement {
    actions = [
      "elasticloadbalancing:SetWebAcl",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:AddListenerCertificates",
      "elasticloadbalancing:RemoveListenerCertificates",
      "elasticloadbalancing:ModifyRule"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}


resource "helm_release" "aws-load-balancer-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.1.2"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = var.name
  }

  set {
    name  = "enableShield"
    value = "false"
  }

  set {
    name  = "enableWaf"
    value = "false"
  }

  set {
    name  = "enableWafv2"
    value = "false"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.alb_ingress_iam_role.this_iam_role_arn
  }
}
