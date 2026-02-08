output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.NTI_eks.name
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = aws_eks_cluster.NTI_eks.arn
}

output "cluster_endpoint" {
  description = "EKS cluster API server endpoint"
  value       = aws_eks_cluster.NTI_eks.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required for kubeconfig"
  value       = aws_eks_cluster.NTI_eks.certificate_authority[0].data
}

output "cluster_version" {
  description = "Kubernetes version of the cluster"
  value       = aws_eks_cluster.NTI_eks.version
}

output "cluster_platform_version" {
  description = "EKS platform version"
  value       = aws_eks_cluster.NTI_eks.platform_version
}

output "cluster_security_group_id" {
  description = "Security group id attached to the cluster control plane"
  value       = aws_eks_cluster.NTI_eks.vpc_config[0].cluster_security_group_id
}

output "cluster_primary_security_group_id" {
  description = "Primary security group id created by EKS for the cluster"
  value       = aws_eks_cluster.NTI_eks.vpc_config[0].cluster_security_group_id
}

output "nodegroup_name" {
  description = "Managed node group name"
  value       = try(aws_eks_node_group.NTI_NODE_GR.node_group_name, null)
}

output "nodegroup_arn" {
  description = "Managed node group ARN"
  value       = try(aws_eks_node_group.NTI_NODE_GR.arn, null)
}

output "nodegroup_status" {
  description = "Managed node group status"
  value       = try(aws_eks_node_group.NTI_NODE_GR.status, null)
}

output "eks_cluster_role_arn" {
  description = "IAM role ARN used by EKS control plane"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  description = "IAM role ARN used by worker nodes"
  value       = aws_iam_role.eks_node_role.arn
}
output "aws_lbc_role_arn" {
  value = aws_iam_role.aws_lbc_role.arn
}
