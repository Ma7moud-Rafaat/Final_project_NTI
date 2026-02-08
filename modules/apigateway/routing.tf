############################################
# routing.tf
# - Integration (HTTP API -> VPC Link -> NLB Listener)
# - Routes (root + proxy)
# - Stage ($default auto deploy)
############################################

# Required inputs:
# - aws_apigatewayv2_api.this
# - aws_apigatewayv2_vpc_link.this
# - var.nlb_listener_arn
# - var.tags

resource "aws_apigatewayv2_integration" "nlb_proxy" {
  api_id = aws_apigatewayv2_api.NTI_API.id

  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"

  connection_type = "VPC_LINK"
  connection_id   = aws_apigatewayv2_vpc_link.VPC-LINK.id

  # MUST be the NLB Listener ARN (e.g. :80 or :443)
  integration_uri = var.nlb_listener_arn

  payload_format_version = "1.0"
  timeout_milliseconds   = 29000

}

# Route for /
resource "aws_apigatewayv2_route" "root" {
  api_id    = aws_apigatewayv2_api.NTI_API.id
  route_key = "ANY /"

  target = "integrations/${aws_apigatewayv2_integration.nlb_proxy.id}"
}

# Catch-all proxy route
resource "aws_apigatewayv2_route" "proxy" {
  api_id    = aws_apigatewayv2_api.NTI_API.id
  route_key = "ANY /{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.nlb_proxy.id}"
}

# Default stage with auto deploy
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.NTI_API.id
  name        = "$default"
  auto_deploy = true

  tags = var.tags
}
