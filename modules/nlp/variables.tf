variable "name" {
  type = string
}
variable "internal" {
  type = string
}
variable "subnets" {
  type = list(string)
}
variable "lb_target_port" {
  type = string
}
variable "vpc_id" {
}
variable "lb_listener_port" {
 type = string
}

