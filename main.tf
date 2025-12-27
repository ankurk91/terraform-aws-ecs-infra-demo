terraform {
  backend "s3" {
    # Note: Verify these before creating infra
    bucket               = "cosmic-terraform-state-bucket"
    key                  = "cosmic/terraform.tfstate"
    region               = "ap-south-1"
    profile              = "cosmic"
    encrypt              = true
    use_lockfile         = true
    workspace_key_prefix = "workspaces"
  }

  required_version = ">= 1.14.0"
}

module "main-app" {
  source                             = "./infra"
  aws_region                         = var.aws_region
  project_name                       = lower(var.project_name)

  acm_domain_names                   = [var.backend_app_domain]
  backend_app_domain                 = var.backend_app_domain
  s3_suffix_domain                   = var.s3_suffix_domain
  dns_records_updated                = var.dns_records_updated

  mongo_private_key                  = var.mongo_private_key
  mongo_public_key                   = var.mongo_public_key
  mongo_db_user_password             = var.mongo_db_user_password
  mongo_org_id                       = var.mongo_org_id

  alert_notification_emails = split(",", var.alert_notification_emails)
}
