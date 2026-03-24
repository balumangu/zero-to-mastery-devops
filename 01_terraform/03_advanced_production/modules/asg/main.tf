resource "aws_iam_role" "ssm_role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = { Service = "ec2.amazonaws.com" },
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "profile" {
  role = aws_iam_role.ssm_role.name
}

resource "aws_launch_template" "lt" {
  image_id      = "ami-0ec10929233384c7f"
  instance_type = "t2.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.profile.name
  }

  vpc_security_group_ids = [var.ec2_sg]

user_data = base64encode(templatefile(var.user_data, {
  # Change the key name on the left to match the variable in your .sh script
  db_endpoint = var.db_host
  db_username = var.db_user
  db_password = var.db_pass
  db_name     = var.db_name
  s3_bucket   = var.s3_bucket
  }))
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity = 2
  max_size         = 2
  min_size         = 2

  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [var.tg_arn]
}