variable "project_prefix" {
  type = string
}

variable "ami_id" {
  description = "AMI id for the EC2 instance for current region"
  type = string
  # https://cloud-images.ubuntu.com/locator/ec2/
  default     = "ami-0cb29b37e51981ef2"
}

variable "public_subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}


