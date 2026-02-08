resource "aws_eip" "nat" {
  domain = "vpc"
}
resource "aws_nat_gateway" "gw_nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id
  depends_on = [aws_internet_gateway.gw]

  tags = {
    Name = "gw NAT"
  }

}