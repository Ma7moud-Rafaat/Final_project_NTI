terraform {
  backend "s3" {
    bucket = "mybucket12345m"
    key    = "terraform"
    region = "us-east-1"
  }
}
