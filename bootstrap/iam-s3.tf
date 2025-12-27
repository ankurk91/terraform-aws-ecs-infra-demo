resource "aws_iam_role" "frontend_service_deployment_role" {
  name = "${var.project_name}-frontend-deploy-assume-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_user.frontend_service_deployment_user.arn
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "frontend_service_deployment_role_policy" {
  name        = "${var.project_name}-frontend-deploy-role-policy"
  description = "Frontend Service Deployment Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource : "arn:aws:s3:::*/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "cloudfront:CreateInvalidation",
          "cloudfront:GetInvalidation",
          "cloudfront:ListInvalidations"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "frontend_role_policy_attachment" {
  role       = aws_iam_role.frontend_service_deployment_role.name
  policy_arn = aws_iam_policy.frontend_service_deployment_role_policy.arn
}

resource "aws_iam_user" "frontend_service_deployment_user" {
  name = "${var.project_name}-frontend-deploy-user"
}

resource "aws_iam_policy" "frontend_service_deployment_user_policy" {
  name        = "${var.project_name}-frontend-deploy-user-policy"
  description = "Policy to allow user to assume a role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = aws_iam_role.frontend_service_deployment_role.arn
      },
    ]
  })
}

resource "aws_iam_user_policy_attachment" "frontend_user_assume_role_policy_attachment" {
  user       = aws_iam_user.frontend_service_deployment_user.name
  policy_arn = aws_iam_policy.frontend_service_deployment_user_policy.arn
}

