locals {
  default_elasticache_config = {
    node_type                  = "cache.t4g.micro"
    num_cache_clusters         = 1
    multi_az_enabled           = false
    automatic_failover_enabled = false
  }

  elasticache_configs = {
    dev     = local.default_elasticache_config
    staging = local.default_elasticache_config
    prod = {
      node_type                  = "cache.t4g.small"
      num_cache_clusters         = 2
      multi_az_enabled           = true
      automatic_failover_enabled = true
    }
  }

  current_elasticache_config = lookup(local.elasticache_configs, terraform.workspace, local.default_elasticache_config)

  node_type                  = local.current_elasticache_config.node_type
  num_cache_clusters         = local.current_elasticache_config.num_cache_clusters
  multi_az_enabled           = local.current_elasticache_config.multi_az_enabled
  automatic_failover_enabled = local.current_elasticache_config.automatic_failover_enabled
}

resource "aws_elasticache_replication_group" "elasticache_replication_group" {
  replication_group_id = "${var.project_prefix}-valkey-elasticache"
  description          = "Valkey Elasticache"

  engine                     = "valkey"
  apply_immediately          = true
  auto_minor_version_upgrade = true
  node_type                  = local.node_type
  num_cache_clusters         = local.num_cache_clusters
  automatic_failover_enabled = local.automatic_failover_enabled
  multi_az_enabled           = local.multi_az_enabled
  port                       = 6379
  network_type               = "ipv4"
  at_rest_encryption_enabled = true
  engine_version             = "8.2"

  subnet_group_name = aws_elasticache_subnet_group.elasticache_subnet_group.name
  security_group_ids = [aws_security_group.elasticache_security_group.id]

  snapshot_retention_limit = 2
  snapshot_window          = "08:30-09:30"
  maintenance_window       = "tue:07:00-tue:08:00"
  notification_topic_arn = aws_sns_topic.elasticache_notification_sns_topic.arn

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.elasticache_slow_log_group.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.elasticache_engine_log_group.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "engine-log"
  }

  lifecycle {
    ignore_changes = [num_cache_clusters]
  }

  tags = {
    Name = "${var.project_prefix}-elasticache"
  }
}

resource "aws_cloudwatch_log_group" "elasticache_slow_log_group" {
  name              = "/elasticache/${var.project_prefix}/valkey/slow"
  retention_in_days = 7
  skip_destroy      = false
}

resource "aws_cloudwatch_log_group" "elasticache_engine_log_group" {
  name              = "/elasticache/${var.project_prefix}/valkey/engine"
  retention_in_days = 1
  skip_destroy      = false
}

resource "aws_elasticache_subnet_group" "elasticache_subnet_group" {
  name       = "${var.project_prefix}-elasticache-subnet-group"
  subnet_ids = var.private_subnets_ids
}
