locals {
  containerName = "backend-container"
  containerPort = var.app_container_port

  default_service_config = {
    desired_count = 1
  }

  service_config = {
    dev     = local.default_service_config
    staging = local.default_service_config
    prod = {
      desired_count = 2
    }
  }

  current_service_config = lookup(local.service_config, terraform.workspace, local.default_service_config)
  desired_count = local.current_service_config.desired_count
}

resource "aws_ecs_service" "backend_ecs_service" {
  name                               = "${var.project_prefix}-backend-service"
  cluster                            = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.backend_ecs_task_definition.arn
  desired_count                      = local.desired_count
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50
  enable_execute_command = true

  load_balancer {
    target_group_arn = aws_lb_target_group.backend_target_group.arn
    container_name   = local.containerName
    container_port   = local.containerPort
  }

  network_configuration {
    subnets          = var.private_subnets_ids
    security_groups = [aws_security_group.backend_ecs_service_security_group.id]
    assign_public_ip = false
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
}
