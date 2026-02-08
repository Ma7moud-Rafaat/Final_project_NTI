output "eks_cluster_name" {
  value = module.EKS.cluster_name
}
output "vpc_id" {
  value = module.neywork.vpc_id
}
output "region" {
  value = local.region
}
output "private_subnet_ids" {
  value = module.neywork.private_subnet_ids
}
output "apigw_api_endpoint" {
  value = module.apigateway.api_endpoint
}
output "apigw_vpclink_id" {
  value = module.apigateway.vpclink_id
}
output "ingress_nlb_target_group_arn" {
  value = module.nlb.target_group_arn
}
output "ingress_nlb_listener_arn" {
  value = module.nlb.listener_arn
}
output "ingress_nlb_dns" {
  value = module.nlb.nlb_dns
}
output "aws_lbc_role_arn" {
  value = module.EKS.aws_lbc_role_arn
}
output "http_api_endpoint" {
value = module.apigateway.http_api_endpoint
}