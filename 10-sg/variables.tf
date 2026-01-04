variable "project_name" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "sg_names" {
  default = [
    "mongodb", "redis", "mysql", "rabbitmq",
    
    "bastion", "openvpn",

    "ingress_alb",
    
    "eks_control_plane", "eks_node"
  ]
}