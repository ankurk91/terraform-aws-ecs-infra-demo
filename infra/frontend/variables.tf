variable "project_prefix" {
  type = string
}

variable "s3_suffix_domain" {
  description = "A valid domain to be used in the S3 bucket name as suffix, ex: example.com"
  type        = string
}
