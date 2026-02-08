variable "api_name" {
  type        = string
  description = "API Gateway HTTP API name"
}
variable "vpc_id" {
  type        = string
  description = "VPC id for VPC Link SG"
}
variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet ids for VPC Link"
}
variable "tags" {
  type        = map(string)
  default     = {}
}