resource "aws_lb" "main_alb" {
  name                       = "${var.project_prefix}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups = [aws_security_group.alb_security_group.id]
  subnets                    = var.public_subnets_ids
  enable_deletion_protection = false
  idle_timeout               = 60
  enable_http2               = true
  ip_address_type            = "ipv4"

  access_logs {
    bucket  = aws_s3_bucket.alb_access_logs_s3.bucket
    prefix  = "alb-logs"
    enabled = true
  }
}

resource "aws_lb_listener" "main_alb_listener" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = var.dns_records_updated ? 443 : 80
  protocol          = var.dns_records_updated ? "HTTPS" : "HTTP"
  certificate_arn   = var.dns_records_updated ? aws_acm_certificate.acm_certificate.arn : null

  # We will be using listener rules for routing
  # based on host header
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "No matching rule found"
      status_code  = "404"
    }
  }

  tags = {
    Name = "${var.project_prefix}-main-alb-listener"
  }
}

output "alb_dns_name" {
  value = aws_lb.main_alb.dns_name
}