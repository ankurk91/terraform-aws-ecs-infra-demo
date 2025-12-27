locals {
  ssmPrefix = "backend-api"
}

# todo you need to manually place the actual values via AWS Console

resource "aws_ssm_parameter" "backend_app_ssm_database_url" {
  name        = "/${var.project_prefix}/${local.ssmPrefix}/DATABASE_URL"
  description = "Mongo Database Connection String"
  type        = "SecureString"
  value       = "example-value"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "backend_app_redis_host" {
  name        = "/${var.project_prefix}/${local.ssmPrefix}/REDIS_HOST"
  description = "Elasticache HOST"
  type        = "SecureString"
  value       = "localhost"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "backend_app_ssm_jwt_public_key" {
  name        = "/${var.project_prefix}/${local.ssmPrefix}/JWT_PUBLIC_KEY"
  description = "JWT public Key"
  type        = "SecureString"
  value       = "example-value"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "backend_app_ssm_auth_api_base_url" {
  name        = "/${var.project_prefix}/${local.ssmPrefix}/AUTH_API_BASE_URL"
  description = "URL of the Auth API Service"
  type        = "String"
  value       = "example-value"

  lifecycle {
    ignore_changes = [value]
  }
}


resource "aws_ssm_parameter" "backend_app_ssm_client_id" {
  name        = "/${var.project_prefix}/${local.ssmPrefix}/CLIENT_ID"
  description = "Oauth client id"
  type        = "SecureString"
  value       = "example-value"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "backend_app_ssm_client_secret" {
  name        = "/${var.project_prefix}/${local.ssmPrefix}/CLIENT_SECRET"
  description = "Oauth client secret"
  type        = "SecureString"
  value       = "secret"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "backend_app_ssm_client_redirect_uri" {
  name        = "/${var.project_prefix}/${local.ssmPrefix}/CLIENT_REDIRECT_URI"
  description = "Oauth client redirect uri"
  type        = "String"
  value       = "http://localhost"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "backend_app_ssm_client_redirect_uri_user" {
  name        = "/${var.project_prefix}/${local.ssmPrefix}/CLIENT_REDIRECT_URI_USER"
  description = "Oauth client redirect uri user"
  type        = "String"
  value       = "example-value"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "backend_app_ssm_firebase_service_account_key" {
  name        = "/${var.project_prefix}/${local.ssmPrefix}/FIREBASE_SERVICE_ACCOUNT_KEY"
  description = "Firebase Service Account Key JSON"
  type        = "SecureString"
  value       = "{name: example-value}"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "backend_app_ssm_aws_s3_cdn_url" {
  name        = "/${var.project_prefix}/${local.ssmPrefix}/AWS_S3_CDN_URL"
  description = "S3 CDN URL"
  type        = "String"
  value       = "http://localhost"

  lifecycle {
    ignore_changes = [value]
  }
}
