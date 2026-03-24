variable "vpc_cidr" {}
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "azs" { type = list(string) }

variable "db_user" {}

variable "db_name" {}

variable "bucket_name" {}

variable "db_password" {
  description = "RDS database password"
  type        = string
  sensitive   = true
}