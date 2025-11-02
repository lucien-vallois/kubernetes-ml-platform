output "iam_role_arn" {
  description = "ARN of IAM role"
  value       = module.irsa.iam_role_arn
}

output "iam_role_name" {
  description = "Name of IAM role"
  value       = module.irsa.iam_role_name
}



