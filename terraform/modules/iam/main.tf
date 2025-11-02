# IAM Roles for Service Accounts (IRSA)
module "irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = var.role_name

  oidc_providers = var.oidc_providers

  role_policy_arns = var.role_policy_arns

  tags = var.tags
}



