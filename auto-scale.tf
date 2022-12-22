
# Create an autoscaling based on the cluster and service
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.autoscale_config.max
  min_capacity       = var.autoscale_config.min
  resource_id        = "service/${aws_ecs_cluster.ecs.name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# =========== Scaling
# Scale up
resource "aws_appautoscaling_policy" "up_policy" {
  name               = "nginx_scale_up_policy"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.autoscale_metric.cooldown
    metric_aggregation_type = "Maximum"
    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = var.autoscale_metric.up
    }
  }
}

# Scale down
resource "aws_appautoscaling_policy" "down_policy" {
  name               = "nginx_scale_down_policy"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.autoscale_metric.cooldown
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = var.autoscale_metric.down
    }
  }
}

# =========== Define metrics for the cpu
# High
resource "aws_cloudwatch_metric_alarm" "high_cpu_service" {
  alarm_name          = "nginx_cpu_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  period              = var.autoscale_metric.period
  evaluation_periods  = var.autoscale_metric.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  threshold           = var.autoscale_metric.max_threshold

  dimensions = {
    ClusterName = aws_ecs_cluster.ecs.name
    ServiceName = aws_ecs_service.service.name
  }

  alarm_actions = [aws_appautoscaling_policy.up_policy.arn]
}

# Low
resource "aws_cloudwatch_metric_alarm" "low_cpu_service" {
  alarm_name          = "nginx_cpu_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  period              = var.autoscale_metric.period
  evaluation_periods  = var.autoscale_metric.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  threshold           = var.autoscale_metric.min_threshold

  dimensions = {
    ClusterName = aws_ecs_cluster.ecs.name
    ServiceName = aws_ecs_service.service.name
  }

  alarm_actions = [aws_appautoscaling_policy.down_policy.arn]
}
