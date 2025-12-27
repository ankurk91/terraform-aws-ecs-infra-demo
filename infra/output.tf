output "domain_validation_options" {
  value       = module.ecs.domain_validation_options
  description = "ACM Certificate domain validation options"
}

output "alb_dns_name" {
  value = module.ecs.alb_dns_name
}

