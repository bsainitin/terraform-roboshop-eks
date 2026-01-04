# DATABASE - MONGODB SG RULE
resource "aws_security_group_rule" "mongodb_bastion" {
  type                     = "ingress"
  security_group_id        = local.mongodb_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
}

# DATABASE - REDIS SG RULE
resource "aws_security_group_rule" "redis_bastion" {
  type                     = "ingress"
  security_group_id        = local.redis_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
}

# DATABASE - MYSQL SG RULE
resource "aws_security_group_rule" "mysql_bastion" {
  type                     = "ingress"
  security_group_id        = local.mysql_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
}

# RABBITMQ - RABBITMQ SG RULE
resource "aws_security_group_rule" "rabbitmq_bastion" {
  type                     = "ingress"
  security_group_id        = local.rabbitmq_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
}

# INGRESS ALB SG RULE
resource "aws_security_group_rule" "ingress_alb_public" {
  type              = "ingress"
  security_group_id = local.ingress_alb_sg_id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
}

# BASTION SG RULE
resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  security_group_id = local.bastion_sg_id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

# OPEN VPN SG RULES
resource "aws_security_group_rule" "openvpn_public" {
  type              = "ingress"
  security_group_id = local.openvpn_sg_id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

resource "aws_security_group_rule" "openvpn_443" {
  type              = "ingress"
  security_group_id = local.openvpn_sg_id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
}

resource "aws_security_group_rule" "openvpn_943" {
  type              = "ingress"
  security_group_id = local.openvpn_sg_id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
}

resource "aws_security_group_rule" "openvpn_1194" {
  type              = "ingress"
  security_group_id = local.openvpn_sg_id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
}

# ALL COMPONENTS ALLOWING CONNECTION FROM OPEN VPN
resource "aws_security_group_rule" "components_openvpn" {
  for_each                 = local.vpn_ingress_rules
  type                     = "ingress"
  security_group_id        = each.value.sg_id
  source_security_group_id = local.openvpn_sg_id
  from_port                = each.value.port
  to_port                  = each.value.port
  protocol                 = "tcp"
}

# EKS CONTROL PLANE SG RULES
resource "aws_security_group_rule" "eks_control_plane_bastion" {
  type                     = "ingress"
  security_group_id        = local.eks_control_plane_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
}

# EKS control plane can accept all kind of traffic from EKS nodes
resource "aws_security_group_rule" "eks_control_plane_eks_node" {
  type                     = "ingress"
  security_group_id        = local.eks_control_plane_sg_id
  source_security_group_id = local.eks_node_sg_id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

# EKS NODE SG RULES
resource "aws_security_group_rule" "eks_node_bastion" {
  type                     = "ingress"
  security_group_id        = local.eks_node_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
}

# EKS nodes can accept all kind of traffic from EKS control plane
resource "aws_security_group_rule" "eks_node_eks_control_plane" {
  type                     = "ingress"
  security_group_id        = local.eks_node_sg_id
  source_security_group_id = local.eks_control_plane_sg_id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

# Mandatory for pod to pod communication, because pods can be in any node in VPC CIDR
resource "aws_security_group_rule" "eks_node_vpc" {
  type              = "ingress"
  security_group_id = local.eks_node_sg_id
  cidr_blocks       = ["10.0.0.0/16"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}