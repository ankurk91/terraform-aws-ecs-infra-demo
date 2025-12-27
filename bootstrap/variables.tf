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
    condition = can(regex("^[a-zA-Z-]+$", var.project_name))
    error_message = "Value must contain only alphabetic characters and dashes."
  }
}

variable "terraform_state_s3_bucket_name" {
  description = "Unique S3 Bucket name for state files"
  type        = string
  # Dont change bucket name once it is created
  default     = "cosmic-terraform-state-bucket"
}
