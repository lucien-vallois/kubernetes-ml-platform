variable "role_name" {
  description = "Name of IAM role"
  type        = string
}

variable "oidc_providers" {
  description = "Map of OIDC providers for IRSA"
  type        = any
}

variable "role_policy_arns" {
  description = "ARNs of IAM policies to attach to the role"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}



