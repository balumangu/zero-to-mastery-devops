variable "private_subnets" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "rds_sg" {
  description = "RDS security group"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_user" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}