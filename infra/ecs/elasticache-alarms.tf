resource "aws_cloudwatch_metric_alarm" "elasticache_cpu_utilization_alarm_high" {
  alarm_name          = "${var.project_prefix}-elasticache-cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  datapoints_to_alarm = 5
  metric_name         = "EngineCPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = 60
  statistic           = "Average"
  threshold           = 90
  treat_missing_data  = "missing"

  dimensions = {
    # Primary cluster only
    CacheClusterId = format("%s-%03d", aws_elasticache_replication_group.elasticache_replication_group.id, 1)
  }

  alarm_actions = [aws_sns_topic.elasticache_notification_sns_topic.arn]
  alarm_description = "This alarm monitors CPU utilization of the ElastiCache."
}

resource "aws_cloudwatch_metric_alarm" "elasticache_memory_usage_alarm_high" {
  alarm_name          = "${var.project_prefix}-elasticache-memory-usage-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  datapoints_to_alarm = 5
  metric_name         = "DatabaseMemoryUsagePercentage"
  namespace           = "AWS/ElastiCache"
  period              = 60
  statistic           = "Average"
  threshold           = 90
  treat_missing_data  = "missing"

  dimensions = {
    # Primary cluster only
    CacheClusterId = format("%s-%03d", aws_elasticache_replication_group.elasticache_replication_group.id, 1)
  }

  alarm_actions = [aws_sns_topic.elasticache_notification_sns_topic.arn]
  alarm_description = "This alarm monitors Database Memory Usage of the ElastiCache."
}

