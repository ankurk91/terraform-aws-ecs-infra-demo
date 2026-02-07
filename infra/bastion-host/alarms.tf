resource "aws_cloudwatch_metric_alarm" "status_check_failed" {
  alarm_name          = "${var.project_prefix}-bastion-host-ec2-status-check-failed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Maximum"
  threshold           = 0.99
  alarm_description   = "Status check failed for ${var.project_prefix}-bastion-host-ec2"
  treat_missing_data  = "breaching"

  dimensions = {
    InstanceId = aws_instance.bastion_host_ec2.id
  }

  tags = {
    Name = "${var.project_prefix}-bastion-host-ec2-status-check-failed"
  }
}
