locals {
  # Default values for when workspace is not explicitly defined in the map
  default_config = {
    requestPerTarget = 500
    MinCapacity      = 1
    MaxCapacity      = 2
  }

  scaling_config = {
    dev = local.default_config
    staging = local.default_config
    prod = {
      requestPerTarget = 4000
      MinCapacity      = 2
      MaxCapacity      = 10
    }
  }

  current_scaling_config = lookup(local.scaling_config, terraform.workspace, local.default_config)

  requestPerTarget = local.current_scaling_config.requestPerTarget
  MinCapacity      = local.current_scaling_config.MinCapacity
  MaxCapacity      = local.current_scaling_config.MaxCapacity
  ScaleInCooldown  = 60 # seconds
  ScaleOutCooldown = 60 # seconds
}

resource "aws_appautoscaling_target" "backend_autoscaling_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.backend_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = local.MinCapacity
  max_capacity       = local.MaxCapacity

  tags = {
    Name = "${var.project_prefix}-backend-autoscaling-target"
  }
}

resource "aws_appautoscaling_policy" "backend_autoscaling_policy" {
  name               = "${var.project_prefix}-backend-autoscaling-policy"
  resource_id        = aws_appautoscaling_target.backend_autoscaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.backend_autoscaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.backend_autoscaling_target.service_namespace
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value = local.requestPerTarget
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${var.alb_arn_suffix}/${aws_lb_target_group.backend_target_group.arn_suffix}"
    }

    scale_in_cooldown  = local.ScaleInCooldown
    scale_out_cooldown = local.ScaleOutCooldown
  }
}
