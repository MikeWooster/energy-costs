resource "aws_appautoscaling_target" "webservers" {
  min_capacity       = 1
  max_capacity       = 4
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.webservers.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Scheduled action to scale out at 9am
resource "aws_appautoscaling_scheduled_action" "webservers_scale_out" {
  depends_on = [aws_appautoscaling_target.webservers]

  name               = "mikes-scale-out-action"
  service_namespace  = aws_appautoscaling_target.webservers.service_namespace
  resource_id        = aws_appautoscaling_target.webservers.resource_id
  scalable_dimension = aws_appautoscaling_target.webservers.scalable_dimension
  schedule           = "cron(0 9 * * ? *)"

  scalable_target_action {
    min_capacity = 1
    max_capacity = 4
  }
}

# Scheduled action to scale in at 6pm
resource "aws_appautoscaling_scheduled_action" "webservers_scale_in" {
  depends_on = [aws_appautoscaling_target.webservers]

  name               = "mikes-scale-in-action"
  service_namespace  = aws_appautoscaling_target.webservers.service_namespace
  resource_id        = aws_appautoscaling_target.webservers.resource_id
  scalable_dimension = aws_appautoscaling_target.webservers.scalable_dimension
  schedule           = "cron(0 18 * * ? *)"

  scalable_target_action {
    min_capacity = 0
    max_capacity = 0
  }
}

resource "aws_appautoscaling_policy" "maintain_webservers" {
  name               = "mikes-maintain-webservers-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.webservers.resource_id
  scalable_dimension = aws_appautoscaling_target.webservers.scalable_dimension
  service_namespace  = aws_appautoscaling_target.webservers.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 75
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
