# ---------------------------------------------------------------------------------------------------------------------
# VPC
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-vpc"
  })
}

resource "aws_internet_gateway" "main" {
  depends_on = [aws_vpc.main]

  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-igw"
  })
}

resource "aws_subnet" "public_az1" {
  depends_on = [aws_vpc.main]

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.0.0/24"
  availability_zone = var.az[0]

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-public-subnet-az1"
    Tier = "public"
  })
}

resource "aws_subnet" "public_az2" {
  depends_on = [aws_vpc.main]

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = var.az[1]

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-public-subnet-az2"
    Tier = "public"
  })
}

resource "aws_subnet" "public_az3" {
  depends_on = [aws_vpc.main]

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = var.az[2]

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-public-subnet-az3"
    Tier = "public"
  })
}

data "aws_subnet_ids" "public" {
  depends_on = [aws_subnet.public_az1, aws_subnet.public_az2, aws_subnet.public_az3]

  vpc_id = aws_vpc.main.id
  tags = {
    Tier = "public"
  }
}

resource "aws_subnet" "app_az1" {
  depends_on = [aws_vpc.main]

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.3.0/24"
  availability_zone = var.az[0]

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-app-subnet-az1"
    Tier = "private-app"
  })
}

resource "aws_subnet" "app_az2" {
  depends_on = [aws_vpc.main]

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.4.0/24"
  availability_zone = var.az[1]

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-app-subnet-az2"
    Tier = "private-app"
  })
}

resource "aws_subnet" "app_az3" {
  depends_on = [aws_vpc.main]

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.5.0/24"
  availability_zone = var.az[2]

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-app-subnet-az3"
    Tier = "private-app"
  })
}

data "aws_subnet_ids" "private_app" {
  depends_on = [aws_subnet.app_az1, aws_subnet.app_az2, aws_subnet.app_az3]

  vpc_id = aws_vpc.main.id
  tags = {
    Tier = "private-app"
  }
}

resource "aws_subnet" "db_az1" {
  depends_on = [aws_vpc.main]

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.6.0/24"
  availability_zone = var.az[0]

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-db-subnet-az1"
    Tier = "private-db"
  })
}

resource "aws_subnet" "db_az2" {
  depends_on = [aws_vpc.main]

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.7.0/24"
  availability_zone = var.az[1]

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-db-subnet-az2"
    Tier = "private-db"
  })
}

resource "aws_subnet" "db_az3" {
  depends_on = [aws_vpc.main]

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.8.0/24"
  availability_zone = var.az[2]

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-db-subnet-az3"
    Tier = "private-db"
  })
}

data "aws_subnet_ids" "private_db" {
  depends_on = [aws_subnet.db_az1, aws_subnet.db_az2, aws_subnet.db_az3]

  vpc_id = aws_vpc.main.id
  tags = {
    Tier = "private-db"
  }
}