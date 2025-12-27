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

variable "app_container_port" {
  description = "Docker container port"
  type        = number
  default     = 3001
}

variable "app_domain" {
  description = "A valid domain name for this service, for eg: app.example.com"
  type        = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "private_subnets_ids" {
  type = list(string)
}

variable "alb_arn_suffix" {
  type = string
}

variable "alb_listener_arn" {
  type = string
}

variable "ecs_cluster_id" {
  type = string
}

variable "ecs_services_alarm_topic_arn" {
  type = string
}

variable "s3_suffix_domain" {
  type        = string
}
