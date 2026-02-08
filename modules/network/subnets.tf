resource "aws_subnet" "public" {
  for_each = var.public_subnet_cidrs
  vpc_id                  = aws_vpc.final_project.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "public-${each.key}"
    Type = "public"
  })
}
resource "aws_subnet" "private" {
  for_each = var.private_subnet_cidrs
  vpc_id            = aws_vpc.final_project.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = merge(var.tags, {
    Name = "private-${each.key}"
    Type = "private"
  })
}
resource "aws_subnet" "isolated" {
  for_each = var.isolated_subnet_cidrs

  vpc_id            = aws_vpc.final_project.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = merge(var.tags, {
    Name = "isolated-${each.key}"
    Type = "isolated"
  })
}
