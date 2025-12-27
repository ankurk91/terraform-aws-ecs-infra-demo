resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.ecs_cluster_exe_cmd_kms.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = false
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_cluster_exec_cmd_log_group.name
      }
    }
  }
}

resource "aws_kms_key" "ecs_cluster_exe_cmd_kms" {
  description             = "${var.project_prefix} - ecs execute command"
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" "ecs_cluster_exec_cmd_log_group" {
  name              = "/ecs/${var.project_prefix}/cluster/exec-cmd"
  retention_in_days = 30
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}
