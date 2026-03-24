variable "private_subnets" { type = list(string) }
variable "ec2_sg" {}
variable "tg_arn" {}
variable "user_data" {}

variable "db_host" {}
variable "db_user" {}

variable "db_pass" {
  sensitive = true
}

variable "db_name" {}
variable "s3_bucket" {}