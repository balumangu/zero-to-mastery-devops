module "networking" {
  source = "../modules/networking"

  vpc_cidr = var.vpc_cidr

  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
}

module "security_groups" {
  source = "../modules/security_groups"

  vpc_id = module.networking.vpc_id
}

module "alb" {
  source = "../modules/alb"

  public_subnets = module.networking.public_subnets
  alb_sg         = module.security_groups.alb_sg
  vpc_id         = module.networking.vpc_id
}

module "rds" {
  source = "../modules/rds"

  private_subnets = module.networking.private_subnets
  rds_sg          = module.security_groups.rds_sg

  db_name     = var.db_name
  db_user     = var.db_user
  db_password = var.db_password
}

module "s3" {
  source      = "../modules/s3"
  bucket_name = var.bucket_name
}

module "asg" {
  source = "../modules/asg"

  private_subnets = module.networking.private_subnets
  ec2_sg          = module.security_groups.ec2_sg

  tg_arn = module.alb.target_group_arn

  db_host = module.rds.db_endpoint
  db_user = var.db_user
  db_pass = var.db_password
  db_name = var.db_name

  s3_bucket = var.bucket_name
  user_data = "../scripts/install_app.sh"
}