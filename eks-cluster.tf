module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.0.4"
  cluster_name    = local.cluster_name
  cluster_version = "1.21"
  subnet_ids      = module.vpc.private_subnets
  enable_irsa     = true

  tags = {
    Environment = "karpenter"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = module.vpc.vpc_id

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    disk_size      = 50
    instance_types = ["t3.small", "t3a.small", "t3.medium", "t3a.medium"]
  }
  eks_managed_node_groups = {
    default_node_group = {
      desired_size = 1
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
