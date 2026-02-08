locals {
  vpc_cider        = "10.0.0.0/16"
  vpc_tag          = "final_project_vpc"
  vpc_id           = "aws_vpc.final_project.id"
  name_route_final = "routetable_1"
  name_gw          = "gateway_1"
  subnet_cider     = ["10.0.1.0/24", "10.0.2.0/24"]
  azs              = ["us-east-1a", "us-east-1b"]
  public_subnets_cidrs = {
    "us-east-1a" = "10.0.1.0/24"
    "us-east-1b" = "10.0.2.0/24"
  }
  private_subnet_cidrs = {
    "us-east-1a" = "10.0.11.0/24"
    "us-east-1b" = "10.0.12.0/24"
  }
  isolated_subnets_cidrs = {
    "us-east-1a" = "10.0.21.0/24"
    "us-east-1b" = "10.0.22.0/24"
  }
  tags = {
    Project = "NTI"
    Env     = "prod"
  }
}

locals {
  cluster_name = "NTI_EKS"
  k8s_version  = "1.29"
}
locals {
  node_instance_types       = ["t3.medium"]
  capacity_type             = "ON_DEMAND"
  node_desired_size         = 3
  node_max_size             = 5
  node_min_size             = 1
  max_unavailable           = 1
  enable_node_remote_access = false
  ssh_key_name              = ""
}
locals {
  region = "us-east-1"
  namespaces = {
    argocd = "argocd"
    vault  = "vault"
  }

}
locals {
  api_name = "NTI_API"
}
locals {
  lb_name          = "NTI-LB"
  internal         = "true"
  lb_target_port   = "80"
  lb_listener_port = "80"
}
