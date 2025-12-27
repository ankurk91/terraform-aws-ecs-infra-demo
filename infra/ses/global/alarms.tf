resource "aws_cloudwatch_metric_alarm" "ses_bounce_alarm" {
  alarm_name          = "${var.project_name}-ses-bounce-rate-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm  = 1
  metric_name         = "Reputation.BounceRate"
  namespace           = "AWS/SES"
  period              = 60 * 60
  statistic           = "Maximum"
  threshold           = "0.025"
  treat_missing_data  = "notBreaching"
  alarm_description   = "Alarm at 50% of the recommended warning level for bounces."
  alarm_actions = [aws_sns_topic.ses_sns_topic.arn]
}

resource "aws_cloudwatch_metric_alarm" "ses_complaint_alarm" {
  alarm_name          = "${var.project_name}-ses-complaint-rate-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm  = 2
  metric_name         = "Reputation.ComplaintRate"
  namespace           = "AWS/SES"
  period              = 60 * 60
  statistic           = "Average"
  threshold           = "0.0005"
  treat_missing_data  = "notBreaching"
  alarm_description   = "Alarm at 50% of the recommended warning level for complaints."
  alarm_actions = [aws_sns_topic.ses_sns_topic.arn]
}
