locals {
  isProduction = terraform.workspace == "prod" ? true : false
}

resource "aws_s3_bucket" "backend_s3_bucket" {
  bucket        = "${var.project_prefix}-bucket.${var.s3_suffix_domain}"
  force_destroy = !local.isProduction

  lifecycle {
    #todo check if it still prevent bucket deletion in production
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backend_s3_bucket_encryption" {
  bucket = aws_s3_bucket.backend_s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "backend_s3_bucket_ownership" {
  bucket = aws_s3_bucket.backend_s3_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "backend_s3_bucket_public_access_block" {
  bucket = aws_s3_bucket.backend_s3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "backend_s3_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.backend_s3_bucket_ownership,
    aws_s3_bucket_public_access_block.backend_s3_bucket_public_access_block,
  ]
  bucket = aws_s3_bucket.backend_s3_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "ecs_backend_app_s3_policy" {
  depends_on = [aws_s3_bucket_acl.backend_s3_bucket_acl]
  bucket = aws_s3_bucket.backend_s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadExcludingPrivateFolder"
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject",
        ],
        NotResource = [
          "${aws_s3_bucket.backend_s3_bucket.arn}/private/*",
          "${aws_s3_bucket.backend_s3_bucket.arn}/private"
        ]
      },
      {
        Sid    = "AllowIAMRoleAllActions",
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.backend_ecs_task_execution_role.arn
        }
        Action = "s3:*"
        Resource = [
          "${aws_s3_bucket.backend_s3_bucket.arn}/*",
          aws_s3_bucket.backend_s3_bucket.arn
        ]
      }
    ]
  })
}

resource "aws_s3_bucket_cors_configuration" "backend_s3_bucket_cors" {
  bucket = aws_s3_bucket.backend_s3_bucket.id

  cors_rule {
    allowed_headers = [
      "*"
    ]
    allowed_methods = [
      "GET",
      "HEAD",
      "PUT",
      "POST",
    ]
    allowed_origins = [
      "*"
    ]
    expose_headers = [
      "ETag"
    ]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "backend_s3_bucket_lifecycle" {
  bucket = aws_s3_bucket.backend_s3_bucket.id

  rule {
    id     = "Delete Incomplete Multipart Uploads"
    status = "Enabled"
    filter {
      prefix = "/"
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  rule {
    id     = "Prune Temp files"
    status = "Enabled"
    filter {
      prefix = "temp/"
    }
    expiration {
      days = 1
    }
  }
}

