resource "aws_security_group" "alb_security_group" {
  name        = "${var.project_prefix}-alb-sg"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_prefix}-alb-security-group"
  }
}

resource "aws_security_group" "elasticache_security_group" {
  name        = "${var.project_prefix}-elasticache-sg"
  description = "Security group for ElastiCache"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 6379
    to_port   = 6379
    protocol  = "tcp"
    security_groups = [
      module.backend-service.backend_ecs_service_security_group_id,
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_prefix}-elasticache-sg"
  }
}

output "project_alb_security_group_id" {
  value       = aws_security_group.alb_security_group.id
  description = "ID of the ALB Security group"
}

output "backend_elasticache_security_group_id" {
  value       = aws_security_group.elasticache_security_group.id
  description = "ID of the ElastiCache Security group"
}
