data "aws_caller_identity" "current" {}

module "network" {
  source         = "./network"
  project_prefix = "${terraform.workspace}-${var.project_name}"
  aws_region = var.aws_region
}

module "ecs" {
  source              = "./ecs"
  project_prefix      = "${terraform.workspace}-${var.project_name}"
  aws_account_id      = data.aws_caller_identity.current.account_id
  aws_region          = var.aws_region
  vpc_id              = module.network.vpc_id
  public_subnets_ids  = module.network.public_subnets_ids
  private_subnets_ids = module.network.private_subnets_ids

  acm_domain_names = var.acm_domain_names
  backend_app_domain  = var.backend_app_domain
  s3_suffix_domain = var.s3_suffix_domain
  dns_records_updated = var.dns_records_updated

  ecs_deployment_notification_emails = var.alert_notification_emails
  elasticache_notification_emails = var.alert_notification_emails
  ecs_alerts_notification_emails = var.alert_notification_emails
}

module "frontend" {
  source           = "./frontend"
  project_prefix   = "${terraform.workspace}-${var.project_name}"
  s3_suffix_domain = var.s3_suffix_domain
}

module "rds-aurora" {
  source         = "./rds-aurora"
  project_prefix = "${terraform.workspace}-${var.project_name}"
  vpc_id         = module.network.vpc_id
}

module "bastion-host" {
  source         = "./bastion-host"
  project_prefix = "${terraform.workspace}-${var.project_name}"
  vpc_id         = module.network.vpc_id
  public_subnet_id = module.network.public_subnets_ids[0]
}

module "mongo-backend-db" {
  source = "./mongo-backend-db"
  project_prefix = "${terraform.workspace}-${var.project_name}"
  org_id = var.mongo_org_id
  private_key = var.mongo_private_key
  public_key = var.mongo_public_key
  db_user_password = var.mongo_db_user_password
  region = upper(replace(var.aws_region, "-", "_"))
  ip_addresses = [module.network.nat_gateway_public_ip]
}

module "ses" {
  source = "./ses"
  project_name = var.project_name
  project_prefix = "${terraform.workspace}-${var.project_name}"
  ses_notification_emails = var.alert_notification_emails
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}
