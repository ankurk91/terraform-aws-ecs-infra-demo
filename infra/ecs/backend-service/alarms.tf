resource "aws_cloudwatch_metric_alarm" "ecs_backend_http_5xx_alarm" {
  alarm_name          = "${var.project_prefix}-ecs-backend-service-http-5xx-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm  = 2
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = aws_lb_target_group.backend_target_group.arn_suffix
  }

  alarm_actions = [var.ecs_services_alarm_topic_arn]
  alarm_description = "Alarms when ECS service has too many HTTP 5XX errors."
}

resource "aws_cloudwatch_metric_alarm" "ecs_backend_cpu_utilization_alarm_high" {
  alarm_name          = "${var.project_prefix}-ecs-backend-service-cpu-util-high"
  alarm_description   = "Detects a high CPU utilization of the ECS service."
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  threshold           = 90
  period              = 60
  dimensions = {
    ServiceName = aws_ecs_service.backend_ecs_service.name
    ClusterName = var.ecs_cluster_name
  }
  treat_missing_data = "breaching"
  alarm_actions = [var.ecs_services_alarm_topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "ecs_backend_memory_utilization_alarm_high" {
  alarm_name          = "${var.project_prefix}-ecs-backend-service-memory-util-high"
  alarm_description   = "Detects a high Memory utilization of the ECS service."
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  threshold           = 90
  period              = 60
  dimensions = {
    ServiceName = aws_ecs_service.backend_ecs_service.name
    ClusterName = var.ecs_cluster_name
  }
  treat_missing_data = "breaching"
  alarm_actions = [var.ecs_services_alarm_topic_arn]
}


resource "aws_cloudwatch_metric_alarm" "ecs_backend_active_running_tasks_alarm" {
  alarm_name          = "${var.project_prefix}-ecs-backend-service-running-tasks-low"
  alarm_description   = "This alarm monitors the number of running tasks of the ECS service."
  metric_name         = "RunningTaskCount"
  namespace           = "ECS/ContainerInsights"
  statistic           = "Average"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  threshold           = 1
  period              = 60
  dimensions = {
    ServiceName = aws_ecs_service.backend_ecs_service.name
    ClusterName = var.ecs_cluster_name
  }
  treat_missing_data = "breaching"
  alarm_actions = [var.ecs_services_alarm_topic_arn]
}
