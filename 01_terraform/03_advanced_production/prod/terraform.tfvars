vpc_cidr = "10.0.0.0/16"

public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnets = [
  "10.0.3.0/24",
  "10.0.4.0/24"
]

azs = ["us-east-1a", "us-east-1b"]

db_user = "admin"
db_name = "appdb"

bucket_name = "balumangu-terraform-project-v2"

asg_min     = 2
asg_desired = 2
asg_max     = 6

environment = "prod"