
# Create an autoscaling based on the cluster and service
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.autoscale_config.max
  min_capacity       = var.autoscale_config.min
  resource_id        = "service/${aws_ecs_cluster.ecs.name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# =========== Target Scaling 
# This is an example: app/EC2Co-EcsEl-1TKLTMITMM0EO/f37c06a68c1748aa/targetgroup/EC2Co-Defau-LDNM7Q3ZH1ZN/6d4ea56ca2d6a18d.
resource "aws_appautoscaling_policy" "target_scaling" {
  name               = "nginx-target-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "app/${aws_alb.lb.name}/${basename("${aws_alb.lb.id}")}/targetgroup/${aws_alb_target_group.target.name}/${basename("${aws_alb_target_group.target.id}")}"
    }
    target_value = 10
  }
}

# # =========== Step Scaling
# # Scale up
# resource "aws_appautoscaling_policy" "up_policy" {
#   name               = "nginx_scale_up_policy"
#   resource_id        = aws_appautoscaling_target.ecs_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

#   step_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown                = var.autoscale_metric.cooldown
#     metric_aggregation_type = "Maximum"
#     step_adjustment {
#       metric_interval_lower_bound = 0
#       scaling_adjustment          = var.autoscale_metric.up
#     }
#   }
# }

# # Scale down
# resource "aws_appautoscaling_policy" "down_policy" {
#   name               = "nginx-scale-down-policy"
#   resource_id        = aws_appautoscaling_target.ecs_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

#   step_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown                = var.autoscale_metric.cooldown
#     metric_aggregation_type = "Maximum"

#     step_adjustment {
#       metric_interval_upper_bound = 0
#       scaling_adjustment          = var.autoscale_metric.down
#     }
#   }
# }

# # =========== Define metrics for the cpu
# # High
# resource "aws_cloudwatch_metric_alarm" "high_cpu_service" {
#   alarm_name          = "nginx-cpu-high"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   period              = var.autoscale_metric.period
#   evaluation_periods  = var.autoscale_metric.evaluation_periods
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/ECS"
#   statistic           = "Average"
#   threshold           = var.autoscale_metric.max_threshold

#   dimensions = {
#     ClusterName = aws_ecs_cluster.ecs.name
#     ServiceName = aws_ecs_service.service.name
#   }

#   alarm_actions = [aws_appautoscaling_policy.up_policy.arn]
# }

# # Low
# resource "aws_cloudwatch_metric_alarm" "low_cpu_service" {
#   alarm_name          = "nginx-cpu-down"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   period              = var.autoscale_metric.period
#   evaluation_periods  = var.autoscale_metric.evaluation_periods
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/ECS"
#   statistic           = "Average"
#   threshold           = var.autoscale_metric.min_threshold

#   dimensions = {
#     ClusterName = aws_ecs_cluster.ecs.name
#     ServiceName = aws_ecs_service.service.name
#   }

#   alarm_actions = [aws_appautoscaling_policy.down_policy.arn]
# }
