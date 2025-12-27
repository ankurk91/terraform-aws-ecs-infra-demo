variable "project_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
  default   = "one-time-password"
}

