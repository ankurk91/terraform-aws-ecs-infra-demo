variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "cosmic"

  validation {
    condition     = can(regex("^[a-zA-Z-]+$", var.project_name))
    error_message = "Value must contain only alphabetic characters and dashes."
  }
}

variable "backend_app_domain" {
  description = "A valid domain name, for eg: app.example.com"
  type        = string
}

variable "s3_suffix_domain" {
  description = "A valid domain to be used in the S3 bucket name as suffix, ex: example.com"
  type        = string
}

variable "dns_records_updated" {
  type        = bool
  default     = false
  description = "Set to true if the DNS records have been updated manually"
}

variable "mongo_private_key" {
  sensitive   = true
  description = "MongoDB private key"
  type        = string
}

variable "mongo_public_key" {
  sensitive   = true
  description = "MongoDB public key"
  type        = string
}

variable "mongo_org_id" {
  type        = string
  description = "MongoDB Organization ID"
}

variable "mongo_db_user_password" {
  sensitive   = true
  type        = string
  description = "MongoDB Atlas Database Onetime User Password"
  default     = "one-time-password"
}

variable "alert_notification_emails" {
  description = "Comma separated email addresses to send notifications and alerts"
  type        = string
  default = ""

  validation {
    condition = can(regex("^([\\w.%+-]+@[\\w.-]+\\.[a-zA-Z]{2,},)*[\\w.%+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$", var.alert_notification_emails))
    error_message = "Must be a comma-separated list of valid email addresses."
  }
}
