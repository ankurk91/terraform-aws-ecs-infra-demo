resource "aws_sns_topic" "ses_sns_topic" {
  name         = "${var.project_name}-aws-ses-alerts"
  display_name = "${var.project_name} AWS SES alerts"
}

resource "aws_sns_topic_subscription" "ses_notification_subscription" {
  count = length(var.ses_notification_emails)
  topic_arn = aws_sns_topic.ses_sns_topic.arn
  protocol  = "email"
  endpoint  = var.ses_notification_emails[count.index]
}
