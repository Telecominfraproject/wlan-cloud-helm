
variable "name" {
  description = "Name to use on all resources created"
  type        = string
  default     = "cloudsdk"
}

variable "tags" {
  description = "A map of tags to apply on all resources"
  type        = map(string)
  default     = {}
}

variable "cidr" {
  description = "The CIDR block for the VPC which will be created"
  type        = string
}

variable "eks_cluster_version" {
  description = "Version for EKS cluster"
  type        = string
  default     = "1.18"
}

variable "route53_zone_name" {
  description = "Name of existing Route53 zone that will be used for creating DNS entries and validating certificates"
  type        = string
}

variable "subdomain" {
  description = "Subdomain that all CloudSDK componenents will be created under"
  type        = string
}
