output "website_url" {
  description = "The public DNS URL of the Load Balancer"
  value       = aws_lb.my_alb.dns_name
}