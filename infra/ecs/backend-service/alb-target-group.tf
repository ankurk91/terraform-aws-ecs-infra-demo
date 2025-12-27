resource "aws_lb_target_group" "backend_target_group" {
  name        = "${var.project_prefix}-backend-tg"
  port        = var.app_container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  deregistration_delay = 30
}

resource "aws_lb_listener_rule" "backend_service_listener_rule" {
  listener_arn = var.alb_listener_arn
  priority     = 100

  condition {
    host_header {
      values = [var.app_domain]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_target_group.arn
  }
}

output "backend_alb_target_group_arn" {
  value = aws_lb_target_group.backend_target_group.arn
}
