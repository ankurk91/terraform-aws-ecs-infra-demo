resource "aws_security_group" "backend_ecs_service_security_group" {
  name        = "${var.project_prefix}-backend-ecs-service-sg"
  description = "Security group for ECS Service"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.app_container_port
    to_port     = var.app_container_port
    protocol    = "tcp"
    description = "Allow incoming traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_prefix}-backend-ecs-service-sg"
  }
}

output "backend_ecs_service_security_group_id" {
  value       = aws_security_group.backend_ecs_service_security_group.id
  description = "ID of the ECS service Security group"
}
