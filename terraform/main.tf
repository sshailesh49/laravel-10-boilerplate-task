####################
# VPC MODULE
####################
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = var.vpc_cidr
  azs      = var.azs
}

####################
# EKS MODULE
####################
module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
}

####################
# IAM MODULE
####################
module "iam" {
  source = "./modules/iam"
}

####################
# EKS AUTH DATA
####################
data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

####################
# KUBERNETES PROVIDER
####################
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}
