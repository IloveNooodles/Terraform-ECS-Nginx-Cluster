# =========== Outputing the created dns server
output "alb_hostname" {
  value = aws_alb.lb.dns_name
}
