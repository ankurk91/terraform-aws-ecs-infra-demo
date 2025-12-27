resource "aws_cloudfront_origin_access_control" "frontend_s3_origin_access" {
  name                              = "${var.project_prefix}-s3-cdn-access-control"
  description                       = "${var.project_prefix}-s3-cdn-access-control"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "frontend_s3_cdn_distribution" {
  origin {
    domain_name              = aws_s3_bucket.frontend_s3_bucket.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.frontend_s3_bucket.id
    origin_access_control_id = aws_cloudfront_origin_access_control.frontend_s3_origin_access.id
  }

  enabled             = true
  wait_for_deployment = false
  default_root_object = "index.html"
  comment             = "${var.project_prefix}-s3-cdn"
  price_class         = "PriceClass_200"
  http_version        = "http2and3"

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD", "OPTIONS"]
    compress         = true
    target_origin_id = aws_s3_bucket.frontend_s3_bucket.id

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = 404
    response_page_path    = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
