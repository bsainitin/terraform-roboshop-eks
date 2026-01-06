module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = local.common_name_suffix
  kubernetes_version = "1.33"

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
    metrics-server = {}
  }

  endpoint_public_access                   = false
  enable_cluster_creator_admin_permissions = true

  vpc_id                     = local.vpc_id
  subnet_ids                 = local.private_subnet_ids
  control_plane_subnet_ids   = local.private_subnet_ids
  create_security_group      = false
  create_node_security_group = false
  security_group_id          = local.eks_control_plane_sg_id
  node_security_group_id     = local.eks_node_sg_id

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    # blue = {
    #   # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
    #   ami_type       = "AL2023_x86_64_STANDARD"
    #   instance_types = ["m5.xlarge"]
    #   iam_role_additional_policies = {
    #     amazonEFS = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
    #     amazonEBS = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    #   }

    #   # Cluster nodes autoscaling
    #   min_size     = 2
    #   max_size     = 10
    #   desired_size = 2
    # }

    green = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m5.xlarge"]
      iam_role_additional_policies = {
        amazonEFS = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
        amazonEBS = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }

      # Cluster nodes autoscaling
      min_size     = 2
      max_size     = 10
      desired_size = 2

      # taints = {
      #   upgrade = {
      #     key    = "upgrade"
      #     value  = "true"
      #     effect = "NO_SCHEDULE"
      #   }
      # }
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = local.common_name_suffix
    }
  )
}
