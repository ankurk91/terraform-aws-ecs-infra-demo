output "domain_validation_options" {
  value       = module.main-app.domain_validation_options
  description = "ACM Certificate domain validation options (DNS)"
}

output "alb_dns_name" {
  value       = module.main-app.alb_dns_name
  description = "DNS Name of ALB"
}

