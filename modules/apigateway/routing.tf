# Integrations (3) -> same NLB listener, different Host header

resource "aws_apigatewayv2_integration" "argocd" {
  api_id = aws_apigatewayv2_api.NTI_API.id

  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"

  connection_type = "VPC_LINK"
  connection_id   = aws_apigatewayv2_vpc_link.VPC_LINK.id

  integration_uri         = var.nlb_listener_arn
  payload_format_version  = "1.0"
  timeout_milliseconds    = 29000

  request_parameters = {
    "overwrite:header.Host" = "argocd.${var.domain_base}"
  }

}

resource "aws_apigatewayv2_integration" "vault" {
  api_id = aws_apigatewayv2_api.NTI_API.id

  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"

  connection_type = "VPC_LINK"
  connection_id   = aws_apigatewayv2_vpc_link.VPC_LINK.id

  integration_uri         = var.nlb_listener_arn
  payload_format_version  = "1.0"
  timeout_milliseconds    = 29000

  request_parameters = {
    "overwrite:header.Host" = "vault.${var.domain_base}"
  }

}

resource "aws_apigatewayv2_integration" "nexus" {
  api_id = aws_apigatewayv2_api.NTI_API.id

  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"

  connection_type = "VPC_LINK"
  connection_id   = aws_apigatewayv2_vpc_link.VPC_LINK.id

  integration_uri         = var.nlb_listener_arn
  payload_format_version  = "1.0"
  timeout_milliseconds    = 29000

  request_parameters = {
    "overwrite:header.Host" = "nexus.${var.domain_base}"
  }

}

# Routes (paths)

resource "aws_apigatewayv2_route" "argocd_proxy" {
  api_id    = aws_apigatewayv2_api.NTI_API.id
  route_key = "ANY /argocd/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.argocd.id}"
}

# resource "aws_apigatewayv2_route" "argocd_root_slash" {
#   api_id    = aws_apigatewayv2_api.NTI_API.id
#   route_key = "ANY /argocd/"
#   target    = "integrations/${aws_apigatewayv2_integration.argocd.id}"
# }

resource "aws_apigatewayv2_route" "argocd_root" {
  api_id    = aws_apigatewayv2_api.NTI_API.id
  route_key = "ANY /argocd"
  target    = "integrations/${aws_apigatewayv2_integration.argocd.id}"
}

# ArgoCD static + api + auth

# resource "aws_apigatewayv2_route" "argocd_assets_proxy" {
#   api_id    = aws_apigatewayv2_api.NTI_API.id
#   route_key = "ANY /assets/{proxy+}"
#   target    = "integrations/${aws_apigatewayv2_integration.argocd.id}"
# }

# resource "aws_apigatewayv2_route" "argocd_api_proxy" {
#   api_id    = aws_apigatewayv2_api.NTI_API.id
#   route_key = "ANY /api/{proxy+}"
#   target    = "integrations/${aws_apigatewayv2_integration.argocd.id}"
# }

# resource "aws_apigatewayv2_route" "argocd_auth_proxy" {
#   api_id    = aws_apigatewayv2_api.NTI_API.id
#   route_key = "ANY /auth/{proxy+}"
#   target    = "integrations/${aws_apigatewayv2_integration.argocd.id}"
# }
# # ArgoCD root paths (بدون proxy)

# resource "aws_apigatewayv2_route" "argocd_api_root" {
#   api_id    = aws_apigatewayv2_api.NTI_API.id
#   route_key = "ANY /api"
#   target    = "integrations/${aws_apigatewayv2_integration.argocd.id}"
# }

# resource "aws_apigatewayv2_route" "argocd_auth_root" {
#   api_id    = aws_apigatewayv2_api.NTI_API.id
#   route_key = "ANY /auth"
#   target    = "integrations/${aws_apigatewayv2_integration.argocd.id}"
# }

# resource "aws_apigatewayv2_route" "argocd_assets_root" {
#   api_id    = aws_apigatewayv2_api.NTI_API.id
#   route_key = "ANY /assets"
#   target    = "integrations/${aws_apigatewayv2_integration.argocd.id}"
# }


resource "aws_apigatewayv2_route" "vault_root" {
  api_id    = aws_apigatewayv2_api.NTI_API.id
  route_key = "ANY /vault"
  target    = "integrations/${aws_apigatewayv2_integration.vault.id}"
}
resource "aws_apigatewayv2_route" "vault_proxy" {
  api_id    = aws_apigatewayv2_api.NTI_API.id
  route_key = "ANY /vault/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.vault.id}"
}
# Vault redirects to /ui/*
resource "aws_apigatewayv2_route" "vault_ui_root" {
  api_id    = aws_apigatewayv2_api.NTI_API.id
  route_key = "ANY /ui"
  target    = "integrations/${aws_apigatewayv2_integration.vault.id}"
}

resource "aws_apigatewayv2_route" "vault_ui_proxy" {
  api_id    = aws_apigatewayv2_api.NTI_API.id
  route_key = "ANY /ui/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.vault.id}"
}

# Vault UI calls /v1/*
resource "aws_apigatewayv2_route" "vault_v1_root" {
  api_id    = aws_apigatewayv2_api.NTI_API.id
  route_key = "ANY /v1"
  target    = "integrations/${aws_apigatewayv2_integration.vault.id}"
}

resource "aws_apigatewayv2_route" "vault_v1_proxy" {
  api_id    = aws_apigatewayv2_api.NTI_API.id
  route_key = "ANY /v1/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.vault.id}"
}


resource "aws_apigatewayv2_route" "nexus_proxy" {
  api_id    = aws_apigatewayv2_api.NTI_API.id
  route_key = "ANY /nexus/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.nexus.id}"
}

resource "aws_apigatewayv2_route" "nexus_root" {
  api_id    = aws_apigatewayv2_api.NTI_API.id
  route_key = "ANY /nexus"
  target    = "integrations/${aws_apigatewayv2_integration.nexus.id}"
}

# Default stage

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.NTI_API.id
  name        = "$default"
  auto_deploy = true
  tags        = var.tags
}
