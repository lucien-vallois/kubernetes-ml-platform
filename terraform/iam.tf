# IAM Roles for Service Accounts (IRSA)
module "irsa" {
  source  = "./modules/iam"
  version = "~> 5.0"

  role_name = "${var.cluster_name}-irsa"

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node", "ml-platform:ml-pipeline"]
    }
  }

  role_policy_arns = {
    AmazonEKS_CNI_Policy = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  }

  tags = {
    Environment = var.environment
    Project     = "ml-platform"
  }
}



