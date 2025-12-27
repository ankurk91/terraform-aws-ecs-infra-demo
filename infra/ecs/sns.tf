resource "aws_sns_topic" "ecs_services_alarm_topic" {
  name         = "${var.project_prefix}-ecs-services-alarms"
  display_name = "${var.project_prefix} ECS Service Alarms"
}
resource "aws_sns_topic_subscription" "ecs_services_notification_subscription" {
  count = length(var.ecs_alerts_notification_emails)
  topic_arn = aws_sns_topic.ecs_services_alarm_topic.arn
  protocol  = "email"
  endpoint  = var.ecs_alerts_notification_emails[count.index]
}

resource "aws_sns_topic" "elasticache_notification_sns_topic" {
  name         = "${var.project_prefix}-elasticache-alerts"
  display_name = "${var.project_prefix} elasticache Alert"
}

resource "aws_sns_topic_subscription" "elasticache_notification_subscription" {
  count = length(var.elasticache_notification_emails)
  topic_arn = aws_sns_topic.elasticache_notification_sns_topic.arn
  protocol  = "email"
  endpoint  = var.elasticache_notification_emails[count.index]

  filter_policy = jsonencode({
    "ElastiCache:SnapshotComplete" = [{ "exists" : false }]
  })
  filter_policy_scope = "MessageBody"
}

