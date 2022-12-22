# Outputing the created 
output "alb_hostname" {
  value = aws_alb.lb.dns_name
}
