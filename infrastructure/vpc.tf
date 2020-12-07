# ---------------------------------------------------------------------------------------------------------------------
# VPC
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Mikes VPC"
  }
}

resource "aws_internet_gateway" "main" {
  depends_on = [aws_vpc.main]

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Mikes IGW"
  }
}

resource "aws_subnet" "public_az1" {
  depends_on = [aws_vpc.main]

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.0.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "Mikes Public Subnet AZ1"
  }
}

resource "aws_subnet" "public_az2" {
  depends_on = [aws_vpc.main]

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "Mikes Public Subnet AZ2"
  }
}

resource "aws_subnet" "public_az3" {
  depends_on = [aws_vpc.main]

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "eu-west-1c"

  tags = {
    Name = "Mikes Public Subnet AZ3"
  }
}

resource "aws_subnet" "app_az1" {
  depends_on = [aws_vpc.main]

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.3.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "Mikes Application Subnet AZ1"
  }
}

resource "aws_subnet" "app_az2" {
  depends_on = [aws_vpc.main]

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.4.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "Mikes Application Subnet AZ2"
  }
}

resource "aws_subnet" "app_az3" {
  depends_on = [aws_vpc.main]

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.5.0/24"
  availability_zone = "eu-west-1c"

  tags = {
    Name = "Mikes Application Subnet AZ3"
  }
}

resource "aws_subnet" "db_az1" {
  depends_on = [aws_vpc.main]

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.6.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "Mikes DB Subnet AZ1"
  }
}

resource "aws_subnet" "db_az2" {
  depends_on = [aws_vpc.main]

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.7.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "Mikes DB Subnet AZ2"
  }
}

resource "aws_subnet" "db_az3" {
  depends_on = [aws_vpc.main]

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.8.0/24"
  availability_zone = "eu-west-1c"

  tags = {
    Name = "Mikes DB Subnet AZ3"
  }
}
