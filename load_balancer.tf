# =========== Creating a load balancer
resource "aws_alb" "lb" {
  name            = "nginx-load-balancer"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
}

# =========== Createing a target group
resource "aws_alb_target_group" "target" {
  vpc_id      = aws_vpc.main.id
  name        = "nginx-target-group"
  port        = var.app_type.port
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    path    = "/"
    matcher = "200"
  }
}

# =========== Redirect incoming traffic to target from lb
resource "aws_alb_listener" "listen" {
  load_balancer_arn = aws_alb.lb.arn
  port              = var.app_type.port

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.target.arn
  }
}

