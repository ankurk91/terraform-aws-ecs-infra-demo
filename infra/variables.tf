variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "dns_records_updated" {
  type        = bool
  default     = false
  description = "Set to true if the DNS records have been updated manually"
}

variable "alert_notification_emails" {
  description = "Email addresses to send notifications"
  type        = list(string)
  default = []
}

variable "acm_domain_names" {
  description = "Array of domain names for ACM certificate"
  type = list(string)
}

variable "backend_app_domain" {
  description = "A valid domain name, for eg: api.example.com"
  type        = string
}

variable "s3_suffix_domain" {
  description = "A valid domain to be used in the S3 bucket name as suffix, ex: example.com"
  type        = string
}

variable "mongo_private_key" {
  description = "MongoDB private key"
  type        = string
}

variable "mongo_public_key" {
  description = "MongoDB public key"
  type        = string
}

variable "mongo_org_id" {
  type        = string
  description = "MongoDB Organization ID"
}

variable "mongo_db_user_password" {
  type        = string
  description = "MongoDB Atlas Database User Password"
}


