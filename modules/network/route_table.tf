resource "aws_route_table" "public" {
  vpc_id = aws_vpc.final_project.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.final_project.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw_nat.id
  }
}
resource "aws_route_table" "isolated" {
  vpc_id = aws_vpc.final_project.id
}
