resource "aws_cloudwatch_event_rule" "ecs_deployment_failed" {
  name        = "${var.project_prefix}-ecs-deployment-failed"
  description = "Capture ECS deployment failed events"

  event_pattern = jsonencode({
    source = ["aws.ecs"]
    detail-type = ["ECS Deployment State Change"]
    detail = {
      eventName = ["SERVICE_DEPLOYMENT_FAILED"]
      clusterArn = [aws_ecs_cluster.ecs_cluster.arn]
    }
  })
}

resource "aws_cloudwatch_event_target" "ecs_deployment_failed_sns" {
  rule = aws_cloudwatch_event_rule.ecs_deployment_failed.name
  arn  = aws_sns_topic.ecs_deployment_failed_topic.arn
}

resource "aws_sns_topic" "ecs_deployment_failed_topic" {
  name         = "${var.project_prefix}-ecs-deployment-failed-alerts"
  display_name = "${var.project_prefix} ECS Deployment Failed Alert"
}

resource "aws_sns_topic_policy" "ecs_deployment_failed_sns_policy" {
  arn = aws_sns_topic.ecs_deployment_failed_topic.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEventBridgeToPublish"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.ecs_deployment_failed_topic.arn
      }
    ]
  })
}

resource "aws_sns_topic_subscription" "ecs_deployment_failed_email" {
  count      = length(var.ecs_deployment_notification_emails)
  topic_arn = aws_sns_topic.ecs_deployment_failed_topic.arn
  protocol = "email"
  endpoint  = var.ecs_deployment_notification_emails[count.index]
}
