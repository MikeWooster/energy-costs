# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoints - allow ECS to pull from ECR
# ---------------------------------------------------------------------------------------------------------------------

# Endpoint for the docker registery
resource "aws_vpc_endpoint" "ecr" {
  depends_on = [
    aws_default_security_group.default,
    data.aws_subnet_ids.private_app,
  ]

  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type = "Interface"

  # Deploy in all application subnets (for HA)
  subnet_ids = data.aws_subnet_ids.private_app.ids

  security_group_ids = [
    aws_default_security_group.default.id,
  ]

  private_dns_enabled = true

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-ecr-docker-registry-interface-endpoint"
  })
}

# Endpoint for the ecr api
resource "aws_vpc_endpoint" "ecr_api" {
  depends_on = [
    aws_default_security_group.default,
    data.aws_subnet_ids.private_app
  ]

  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type = "Interface"

  # Deploy in all application subnets (for HA)
  subnet_ids = data.aws_subnet_ids.private_app.ids

  security_group_ids = [
    aws_default_security_group.default.id,
  ]

  private_dns_enabled = true

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-ecr-api-interface-endpoint"
  })
}

# Endpoint for S3
resource "aws_vpc_endpoint" "s3" {
  depends_on = [aws_vpc.main]

  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.s3"

  route_table_ids = [aws_vpc.main.default_route_table_id]

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-s3-gateway-endpoint"
  })
}
