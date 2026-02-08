resource "aws_vpc" "final_project" {
  cidr_block       = var.vpc_cider
  tags = {
    Name = var.vpc_tag
  }
}
# resource "aws_eip" "lb" {
#   instance = aws_instance.web.id
#   domain   = "vpc"
# }

