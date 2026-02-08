variable "vpc_cider" {
    type = string
}
variable "vpc_tag" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "name_route_final" {
  type = string
}
variable "name_gw" {
  type = string
}
variable "azs" {
  type = list(string)
}
variable "public_subnet_cidrs" {
  type = map(string)
}

variable "private_subnet_cidrs" {
  type = map(string)
}

variable "isolated_subnet_cidrs" {
  type = map(string)
}
variable "tags" {
  type = map(string)
  default = {}
}