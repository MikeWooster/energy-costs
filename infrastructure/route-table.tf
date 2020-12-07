
resource "aws_route_table" "public" {
  depends_on = [aws_vpc.main, aws_internet_gateway.main]

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Mikes Public RT"
  }
}

resource "aws_route_table_association" "public_az1" {
  depends_on     = [aws_subnet.public_az1, aws_route_table.public]
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_az2" {
  depends_on     = [aws_subnet.public_az2, aws_route_table.public]
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_az3" {
  depends_on     = [aws_subnet.public_az3, aws_route_table.public]
  subnet_id      = aws_subnet.public_az3.id
  route_table_id = aws_route_table.public.id
}

# Specify the default route table so we have control over it.
# Unassociated subnets will get associted with this implicitly.
resource "aws_default_route_table" "default" {
  depends_on = [aws_vpc.main]

  default_route_table_id = aws_vpc.main.default_route_table_id

  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.main.id
  # }

  tags = {
    Name = "Mikes Default RT"
  }
}
