# EFS for shared storage
module "efs" {
  source  = "terraform-aws-modules/efs/aws"
  version = "~> 1.0"

  name = "${var.cluster_name}-efs"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets
  security_groups = [aws_security_group.efs.id]

  creation_token = "${var.cluster_name}-efs"

  tags = {
    Name        = "${var.cluster_name}-efs"
    Environment = var.environment
  }
}

# Security group for EFS
resource "aws_security_group" "efs" {
  name_prefix = "${var.cluster_name}-efs-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "NFS traffic from VPC"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  tags = {
    Name = "${var.cluster_name}-efs"
  }
}



