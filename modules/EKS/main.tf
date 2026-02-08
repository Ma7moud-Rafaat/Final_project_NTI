resource "aws_eks_cluster" "NTI_eks" {
  name     = var.cluster_name
role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.k8s_version

  vpc_config {
    subnet_ids = var.subnet_ids
        endpoint_private_access = true
    endpoint_public_access  = true
  }
  depends_on = [ aws_iam_role_policy_attachment.eks_cluster_policy,
  aws_iam_role_policy_attachment.eks_service_policy]
}
