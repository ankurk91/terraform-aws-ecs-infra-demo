resource "aws_ses_configuration_set" "ses_configuration_set" {
  name = "${var.project_prefix}-configuration-set"

  reputation_metrics_enabled = true
}

module "global" {
  count                   = terraform.workspace == "dev" ? 1 : 0
  source                  = "./global"
  project_name            = var.project_name
  ses_notification_emails = var.ses_notification_emails
}
