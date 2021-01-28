data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

module "eks" {
  source       = "git::https://github.com/terraform-aws-modules/terraform-aws-eks?ref=v13.2.1"
  cluster_name = var.name
  subnets      = module.vpc.private_subnets
  vpc_id       = module.vpc.vpc_id
  tags         = var.tags

  #workers_group_defaults = {
  #  kubelet_extra_args = "--kube-reserved cpu=500m,memory=500Mi,ephemeral-storage=1Gi --system-reserved cpu=250m,memory=500Mi,ephemeral-storage=1Gi --eviction-hard memory.available<500Mi,nodefs.available<10%"
  #}

  worker_groups = [
    {
      name                 = "worker-group-1"
      asg_desired_capacity = 3
      asg_max_size         = 3
      asg_min_size         = 1
      instance_type        = "m4.large"
    }
  ]

  enable_irsa      = true
  cluster_version  = var.eks_cluster_version
  write_kubeconfig = false
}
