resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier           = "${var.project_prefix}-db-cluster"
  engine                       = "aurora-postgresql"
  engine_version               = "17.7"
  engine_mode                  = "provisioned"
  master_username              = "suprime"
  master_password              = var.db_password
  database_name                = "${terraform.workspace}DB"
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  db_subnet_group_name         = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot          = true
  allow_major_version_upgrade  = true
  apply_immediately            = true
  backup_retention_period      = terraform.workspace == "prod" ? 35 : 7
  copy_tags_to_snapshot        = true
  deletion_protection          = terraform.workspace == "prod" ? true : false
  performance_insights_enabled = terraform.workspace == "prod" ? true : false
  storage_encrypted            = true
  enabled_cloudwatch_logs_exports = ["iam-db-auth-error"]
  preferred_backup_window      = "07:00-08:00"
  preferred_maintenance_window = "Tue:01:00-Tue:02:00"

  lifecycle {
    ignore_changes = [master_password]
  }
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count                = terraform.workspace == "prod" ? 2 : 1
  identifier           = "${var.project_prefix}-db-instance-${count.index + 1}"
  cluster_identifier   = aws_rds_cluster.aurora_cluster.id
  instance_class       = "db.t4g.medium"
  engine               = aws_rds_cluster.aurora_cluster.engine
  engine_version       = aws_rds_cluster.aurora_cluster.engine_version
  db_subnet_group_name = aws_rds_cluster.aurora_cluster.db_subnet_group_name
  publicly_accessible  = false
  force_destroy        = terraform.workspace == "prod" ? false : true
}
