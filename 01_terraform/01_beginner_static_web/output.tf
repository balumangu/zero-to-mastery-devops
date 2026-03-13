output "vpc_id" {
    value = aws_vpc.main.id
}

output "public_subnet_id" {
    value = aws_subnet.public.id
}

output "internet_gateway_id" {
    value = aws_internet_gateway.igw.id
}

output "route_table_id" {
    value = aws_route_table.rt.id
}

output "ec2_instance_id" {
    value = aws_instance.web.id
}