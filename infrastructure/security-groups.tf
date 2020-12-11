# take control of the default security group for the vpc
resource "aws_default_security_group" "default" {
  depends_on = [aws_vpc.main]

  vpc_id = aws_vpc.main.id

  # Allow ingress only from within the vpc network.
  ingress {
    protocol    = "-1"
    self        = true
    from_port   = 0
    to_port     = 0
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  # Allow all egress.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-default-sg"
  })
}

resource "aws_security_group" "public" {
  depends_on = [aws_vpc.main]

  name        = "${local.prefix}-public-sg"
  description = "Allow HTTP/HTTPS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from Anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from Anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all egress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-web-traffic-sg"
  })
}

resource "aws_security_group" "private_app" {
  depends_on = [aws_vpc.main]

  name        = "${local.prefix}-app-sg"
  description = "Allow traffic from public security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow all traffic from the public sg"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.public.id]
  }

  egress {
    description = "Allow all egress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-app-sg"
  })
}
