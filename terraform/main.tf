terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "ml-platform-terraform-state"
    key    = "kubernetes-ml-platform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

