resource "aws_security_group" "sg-vpclink" {
  name        = "${var.api_name}-apigw-vpclink-sg"
  description = "Security group for API Gateway VPC Link"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.api_name}-apigw-vpclink-sg"
  })
}

resource "aws_apigatewayv2_vpc_link" "VPC-LINK" {
  name               = "${var.api_name}-vpclink"
  security_group_ids = [aws_security_group.sg-vpclink.id]
  subnet_ids         = var.private_subnet_ids

  tags = var.tags
}

resource "aws_apigatewayv2_api" "NTI_API" {
  name          = "${var.api_name}-http-api"
  protocol_type = "HTTP"

  tags = var.tags
}
