
# resource "aws_eip" "nat" {
#   depends_on = [aws_internet_gateway.main]

#   vpc = true

#   tags = {
#     Name      = "mikes-nat-eip"
#     CreatedBy = "Mike"
#   }
# }

# resource "aws_nat_gateway" "main" {
#   depends_on = [aws_subnet.public_az1, aws_eip.nat]

#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.public_az1.id

#   tags = {
#     Name      = "mikes-nat"
#     CreatedBy = "Mike"
#   }
# }
