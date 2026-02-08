module "neywork" {
  source                = "../modules/network"
  vpc_id                = local.vpc_id
  vpc_tag               = local.vpc_tag
  vpc_cider             = local.vpc_cider
  name_route_final      = local.name_route_final
  name_gw               = local.name_gw
  isolated_subnet_cidrs = local.isolated_subnets_cidrs
  private_subnet_cidrs  = local.private_subnet_cidrs
  public_subnet_cidrs   = local.public_subnets_cidrs
  azs                   = local.azs
}

module "EKS" {
  source                    = "../modules/EKS"
  k8s_version               = local.k8s_version
  cluster_name              = local.cluster_name
  vpc_id                    = module.neywork.vpc_id
  subnet_ids                = module.neywork.private_subnet_ids
  node_instance_types       = local.node_instance_types
  capacity_type             = local.capacity_type
  node_desired_size         = local.node_desired_size
  node_max_size             = local.node_max_size
  node_min_size             = local.node_min_size
  max_unavailable           = local.max_unavailable
  enable_node_remote_access = local.enable_node_remote_access
  ssh_key_name              = local.ssh_key_name
}

variable "enable_apigateway" {
  type    = bool
  default = false
}

module "apigateway" {
  source             = "../modules/apigateway"
  api_name           = local.api_name
  private_subnet_ids = module.neywork.private_subnet_ids
  vpc_id             = module.neywork.vpc_id
}

module "nlb" {
  source           = "../modules/nlp"
  name             = local.lb_name
  vpc_id           = module.neywork.vpc_id
  subnets          = module.neywork.private_subnet_ids
  lb_listener_port = local.lb_listener_port
  lb_target_port   = local.lb_target_port
  internal         = local.internal
}