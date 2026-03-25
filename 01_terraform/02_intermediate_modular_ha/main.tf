# 1. Call the Network Module
module "my_network" {
  source = "./modules/vpc"

  vpc_cidr           = var.vpc_cidr
  public_sub_1_cidr  = var.public_sub_1_cidr
  public_sub_2_cidr  = var.public_sub_2_cidr
  private_sub_1_cidr = var.private_sub_1_cidr
  private_sub_2_cidr = var.private_sub_2_cidr
  az_1               = var.az_1
  az_2               = var.az_2
}

# 2. Security Groups
resource "aws_security_group" "alb_sg" {
  name   = "alb-security-group"
  vpc_id = module.my_network.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_sg" {
  name   = "ec2-security-group"
  vpc_id = module.my_network.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Application Load Balancer
resource "aws_lb" "my_alb" {
  name               = "my-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [module.my_network.public_subnet_1_id, module.my_network.public_subnet_2_id]
}

resource "aws_lb_target_group" "my_tg" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.my_network.vpc_id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}

# 4. Launch Template & Auto Scaling Group
resource "aws_launch_template" "my_template" {
  name_prefix   = "my-web-server-"
  image_id      = var.ami_id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              apt update -y
              apt install -y apache2
              systemctl start apache2
              systemctl enable apache2
              echo "<h1>Highly Available Setup: Hello from the Private Subnet!</h1>" > /var/www/html/index.html
              EOF
  )
}

resource "aws_autoscaling_group" "my_asg" {
  vpc_zone_identifier = [module.my_network.private_subnet_1_id, module.my_network.private_subnet_2_id]
  target_group_arns   = [aws_lb_target_group.my_tg.arn]
  desired_capacity    = 2
  max_size            = 2
  min_size            = 2

  launch_template {
    id      = aws_launch_template.my_template.id
    version = "$Latest"
  }
}
