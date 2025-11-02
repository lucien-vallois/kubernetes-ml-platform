# EKS Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Groups
  eks_managed_node_groups = {
    # GPU nodes for ML training
    gpu_training = {
      name = "gpu-training-nodes"

      instance_types = ["p3.8xlarge", "p3.16xlarge"]
      capacity_type  = "ON_DEMAND"

      min_size     = 0
      max_size     = 10
      desired_size = 2

      # GPU-specific settings
      ami_type       = "AL2_x86_64_GPU"
      instance_types = ["p3.8xlarge"]

      taints = [
        {
          key    = "nvidia.com/gpu"
          value  = "present"
          effect = "NO_SCHEDULE"
        }
      ]

      labels = {
        "node-type"     = "gpu"
        "workload-type" = "training"
      }

      tags = {
        "k8s.io/cluster-autoscaler/enabled" = "true"
        "k8s.io/cluster-autoscaler/node-template/label/node-type" = "gpu"
      }
    }

    # CPU nodes for inference and general workloads
    cpu_inference = {
      name = "cpu-inference-nodes"

      instance_types = ["m5.2xlarge", "m5.4xlarge"]
      capacity_type  = "SPOT"

      min_size     = 1
      max_size     = 20
      desired_size = 3

      labels = {
        "node-type"     = "cpu"
        "workload-type" = "inference"
      }

      tags = {
        "k8s.io/cluster-autoscaler/enabled" = "true"
        "k8s.io/cluster-autoscaler/node-template/label/node-type" = "cpu"
      }
    }

    # High-memory nodes for data processing
    memory_optimized = {
      name = "memory-optimized-nodes"

      instance_types = ["r5.4xlarge", "r5.8xlarge"]
      capacity_type  = "ON_DEMAND"

      min_size     = 0
      max_size     = 5
      desired_size = 1

      labels = {
        "node-type"     = "memory"
        "workload-type" = "data-processing"
      }
    }
  }

  # Fargate profile for serverless workloads
  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "kube-system"
          labels = {
            k8s-app = "kube-dns"
          }
        },
        {
          namespace = "default"
          labels = {
            "app" = "fargate"
          }
        }
      ]

      tags = {
        Owner = "terraform"
      }
    }
  }

  # Cluster add-ons
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  # Security groups
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  tags = {
    Environment = var.environment
    Project     = "ml-platform"
  }
}

