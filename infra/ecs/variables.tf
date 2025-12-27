# We are not managing the DNS on Route53
# We need to manually update the DNS records
# Set this variable to true if the DNS records have been updated
variable "dns_records_updated" {
  type        = bool
  default     = false
  description = "Set to true if the DNS records have been updated manually"
}

variable "project_prefix" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnets_ids" {
  type = list(string)
}

variable "private_subnets_ids" {
  type = list(string)
}

variable "acm_domain_names" {
  description = "Array of domain names for ACM certificate"
  type = list(string)
}

variable "backend_app_domain" {
  description = "A valid domain name, for eg: app.example.com"
  type        = string
}

variable "s3_suffix_domain" {
  description = "A valid domain to be used in the S3 bucket name as suffix, ex: example.com"
  type        = string
}

variable "ecs_deployment_notification_emails" {
  description = "Email addresses to send notifications for ECS deployment"
  type = list(string)
  default = []
}

variable "elasticache_notification_emails" {
  description = "Email addresses to send notifications for elasticache"
  type = list(string)
  default = []
}

variable "ecs_alerts_notification_emails" {
  description = "Email addresses to send notifications for ECS"
  type = list(string)
  default = []
}
