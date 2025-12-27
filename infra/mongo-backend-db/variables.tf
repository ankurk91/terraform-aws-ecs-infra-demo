variable "region" {
  type        = string
  description = "MongoDB Atlas Cluster Region, must be a region for the provider given"
  default     = "AP_SOUTH_1" # Uppercase and underscore
}

variable "org_id" {
  type        = string
  description = "MongoDB Organization ID"
}

variable "public_key" {
  sensitive = true
  type = string
}

variable "private_key" {
  sensitive = true
  type = string
}

variable "db_user_password" {
  sensitive = true
  type = string
  # It is recommended to change password from Atlas UI after user is created via terraform
  description = "MongoDB Atlas Database User Password"
}

variable "ip_addresses" {
  type = list(string)
  description = "A list of IP addresses or CIDR ranges for accessing the cluster"

  validation {
    condition = alltrue([
      for ip in var.ip_addresses
      : can(regex("^(\\d{1,3}\\.){3}\\d{1,3}(/\\d{1,2})?$", ip)) || can(regex("^(\\d{1,3}\\.){3}\\d{1,3}$", ip))
      ])
    error_message = "Each entry must be a valid IP address or CIDR range."
  }
}

variable "project_prefix" {
  type = string
}
