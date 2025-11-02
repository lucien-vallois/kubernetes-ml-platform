variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "ml-platform-cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.24"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnets" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

# GPU Configuration
variable "gpu_node_groups" {
  description = "GPU node group configurations"
  type = map(object({
    instance_type = string
    min_size      = number
    max_size      = number
    desired_size  = number
  }))
  default = {
    training = {
      instance_type = "p3.8xlarge"
      min_size      = 0
      max_size      = 10
      desired_size  = 2
    }
    inference = {
      instance_type = "p3.2xlarge"
      min_size      = 0
      max_size      = 5
      desired_size  = 1
    }
  }
}

# CPU Configuration
variable "cpu_node_groups" {
  description = "CPU node group configurations"
  type = map(object({
    instance_type = string
    min_size      = number
    max_size      = number
    desired_size  = number
    capacity_type = string
  }))
  default = {
    general = {
      instance_type = "m5.2xlarge"
      min_size      = 1
      max_size      = 20
      desired_size  = 3
      capacity_type = "SPOT"
    }
    memory = {
      instance_type = "r5.4xlarge"
      min_size      = 0
      max_size      = 5
      desired_size  = 1
      capacity_type = "ON_DEMAND"
    }
  }
}

# Storage Configuration
variable "efs_throughput_mode" {
  description = "EFS throughput mode"
  type        = string
  default     = "bursting"
}

variable "s3_versioning" {
  description = "Enable S3 versioning"
  type        = bool
  default     = true
}

# Monitoring Configuration
variable "enable_monitoring" {
  description = "Enable monitoring stack"
  type        = bool
  default     = true
}

variable "prometheus_retention" {
  description = "Prometheus data retention period"
  type        = string
  default     = "30d"
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  sensitive   = true
  default     = ""
}

# Security Configuration
variable "enable_encryption" {
  description = "Enable encryption at rest"
  type        = bool
  default     = true
}

variable "allowed_cidrs" {
  description = "Allowed CIDR blocks for cluster access"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Restrict in production
}

# Tags
variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project     = "ml-platform"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
