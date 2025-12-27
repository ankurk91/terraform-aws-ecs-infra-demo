variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "ses_notification_emails" {
  description = "Email addresses to send notifications"
  type = list(string)
  default = []
}
