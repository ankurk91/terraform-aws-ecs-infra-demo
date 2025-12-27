resource "aws_acm_certificate" "acm_certificate" {
  domain_name               = var.acm_domain_names[0]
  validation_method         = "DNS"
  subject_alternative_names = var.acm_domain_names

  tags = {
    Name = "${var.project_prefix}-acm-certificate"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# We will skip validation until DNS is updated
resource "aws_acm_certificate_validation" "cert_validation" {
  count           = var.dns_records_updated ? 1 : 0
  certificate_arn = aws_acm_certificate.acm_certificate.arn

  validation_record_fqdns = [
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options :dvo.resource_record_name
  ]
}

output "domain_validation_options" {
  value       = aws_acm_certificate.acm_certificate.domain_validation_options
  description = "ACM Certificate domain validation options"
}
