
# Creating security group for load balancer
resource "aws_security_group" "lb" {
  name = "nginx-load-balancer-security-group"
  description = "Allow http to be accepted and forwared to 80"
  vpc_id = aws_vpc.main.id

  # inbound rule accept 80:80
  ingress {
    protocol = "tcp"
    description = "Accepting 80 and forward to 80"
    from_port = var.app_type.port
    to_port = var.app_type.port
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound rule
  egress {
    protocol = "-1" # set to all
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs" {
  name = "nginx-ecs-tasks-security-group"
  description = "Limiting access of ecs to get from alb only"
  vpc_id = aws_vpc.main.id

  # inbound rule accept 80:80 for lb only
  ingress {
    protocol = "tcp"
    description = "Accepting 80 and forward to 80"
    from_port = var.app_type.port
    to_port = var.app_type.port
    security_groups = [aws_security_group.lb.id]
  }

  # outbound rule
  egress {
    protocol = "-1" # set to all
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


