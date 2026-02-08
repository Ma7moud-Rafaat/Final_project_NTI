output "api_id" {
  description = "HTTP API ID"
  value       = aws_apigatewayv2_api.NTI_API.id
}
output "api_endpoint" {
  value = aws_apigatewayv2_api.NTI_API.api_endpoint
}

output "vpclink_id" {
  description = "VPC Link ID"
  value       = aws_apigatewayv2_vpc_link.VPC-LINK.id
}
output "vpclink_sg_id" {
  value = aws_security_group.sg-vpclink.id
}
output "http_api_endpoint" {
  value = aws_apigatewayv2_api.NTI_API.api_endpoint
}
