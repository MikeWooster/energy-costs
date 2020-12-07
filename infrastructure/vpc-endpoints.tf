# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoints - allow ECS to pull from ECR
# ---------------------------------------------------------------------------------------------------------------------

# Endpoint for the docker registery
resource "aws_vpc_endpoint" "ecr" {
  depends_on = [
    aws_default_security_group.default,
    aws_subnet.app_az1,
  ]

  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.eu-west-1.ecr.dkr"
  vpc_endpoint_type = "Interface"

  # cost saving - only putting it in one subnet
  subnet_ids = [aws_subnet.app_az1.id]

  security_group_ids = [
    aws_default_security_group.default.id,
  ]

  private_dns_enabled = true

  tags = {
    Name      = "mikes-ecr-docker-registry-interface-endpoint"
    CreatedBy = "Mike"
  }
}

# Endpoint for the ecr api
resource "aws_vpc_endpoint" "ecr_api" {
  depends_on = [
    aws_default_security_group.default,
    aws_subnet.app_az1,
  ]

  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.eu-west-1.ecr.api"
  vpc_endpoint_type = "Interface"

  subnet_ids = [aws_subnet.app_az1.id]

  security_group_ids = [
    aws_default_security_group.default.id,
  ]

  private_dns_enabled = true

  tags = {
    Name      = "mikes-ecr-api-interface-endpoint"
    CreatedBy = "Mike"
  }
}

# Endpoint for S3
resource "aws_vpc_endpoint" "s3" {
  depends_on = [aws_vpc.main]

  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.eu-west-1.s3"

  route_table_ids = [aws_vpc.main.default_route_table_id]

  tags = {
    Name      = "mikes-s3-gateway-endpoint"
    CreatedBy = "Mike"
  }
}
