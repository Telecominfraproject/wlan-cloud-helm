data "aws_availability_zones" "available" {}

module "vpc" {
  source          = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v2.66.0"
  name            = var.name
  cidr            = var.cidr
  azs             = data.aws_availability_zones.available.names
  private_subnets = [for az in data.aws_availability_zones.available.names : cidrsubnet(var.cidr, 8, index(data.aws_availability_zones.available.names, az))]
  public_subnets  = [for az in data.aws_availability_zones.available.names : cidrsubnet(var.cidr, 8, index(data.aws_availability_zones.available.names, az) + length(data.aws_availability_zones.available.names))]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.name}" = "shared"
    "kubernetes.io/role/elb"            = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.name}" = "shared"
    "kubernetes.io/role/internal-elb"   = "1"
  }

  tags = var.tags
}
