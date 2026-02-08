resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.final_project.id
  tags = merge(var.tags, {
    Name = "igw"
  })
}