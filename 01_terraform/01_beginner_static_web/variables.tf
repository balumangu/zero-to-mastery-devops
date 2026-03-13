variable "region" {
    description = "The default AWS region to create resources in"
    default     = "us-east-1"
}

variable "vpc_cidr_block" {
    description = "The CIDR block for the VPC"
    default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
    description = "The CIDR block for the public subnet"
    default     = "10.0.1.0/24"
}

variable "instance_type" {
    description = "The type of EC2 instance to create"
    default     = "t2.micro"
}

variable "ubuntu_ami" {
    description = "The latest AMI available for Ubuntu in AWS"
    default = "ami-0b6c6ebed2801a5cb"
}

variable "key_name" {
    description = "The SSH key to connect to instance"
    default = "aws_key"
}