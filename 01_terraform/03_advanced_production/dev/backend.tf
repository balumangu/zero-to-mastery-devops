terraform {
  backend "s3" {
    bucket = "balumangu-terraform-project-v2"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}