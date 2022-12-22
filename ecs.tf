# Creating aws ecs cluster
resource "aws_ecs_cluster" "ecs" {
  name = "nginx-cluster"
}

# Creating task definition
data "template_file" "nginx" {
  template = file("./templates/task-definition.json")

  vars = {
    app_image  = var.app_type.image
    app_cpu    = var.aws_launch_type.cpu
    app_memory = var.aws_launch_type.memory
  }
}

resource "aws_ecs_task_definition" "td" {
  family                   = "nginx-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.aws_launch_type.cpu
  memory                   = var.aws_launch_type.memory
  container_definitions    = data.template_file.nginx.rendered
}

# Creating service for the cluster
resource "aws_ecs_service" "service" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.td.arn
  desired_count   = var.app_type.count
  launch_type     = var.aws_launch_type.type

  network_configuration {
    security_groups  = [aws_security_group.ecs.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.target.id
    container_name   = "nginx"
    container_port   = var.app_type.port
  }

  depends_on = [
    aws_alb_listener.listen,
  ]
}


