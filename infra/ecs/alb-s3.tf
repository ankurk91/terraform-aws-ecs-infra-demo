resource "random_id" "unique_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "alb_access_logs_s3" {
  bucket        = "${var.project_prefix}-alb-access-logs-${random_id.unique_id.hex}"
  force_destroy = true

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "alb_s3_bucket_lifecycle" {
  bucket = aws_s3_bucket.alb_access_logs_s3.id

  rule {
    id     = "prune-log-policy"
    status = "Enabled"

    expiration {
      days = 30
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "alb_s3_bucket_ownership_controls" {
  bucket = aws_s3_bucket.alb_access_logs_s3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "alb_s3_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.alb_s3_bucket_ownership_controls]

  bucket = aws_s3_bucket.alb_access_logs_s3.id
  acl    = "private"
}

data "aws_elb_service_account" "default" {}

# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html#attach-bucket-policy
resource "aws_s3_bucket_policy" "alb_logs_s3_policy" {
  bucket = aws_s3_bucket.alb_access_logs_s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          # Need to grant access to this special user
          AWS = data.aws_elb_service_account.default.arn
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.alb_access_logs_s3.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_server_side_encryption_configuration" "alb_s3_bucket_encryption" {
  bucket = aws_s3_bucket.alb_access_logs_s3.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
