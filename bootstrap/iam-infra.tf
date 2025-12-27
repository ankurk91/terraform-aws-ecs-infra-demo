data "aws_caller_identity" "current" {}

resource "aws_iam_role" "infra_deployment_role" {
  name = "${var.project_name}-infra-deploy-assume-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_user.infra_deployment_user.arn
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "infra_deployment_role_policy" {
  name = "${var.project_name}-infra-deploy-role-policy"
  description = "Infra Deployment Policy"

  # Grant admin permission
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "infra_role_policy_attachment" {
  role       = aws_iam_role.infra_deployment_role.name
  policy_arn = aws_iam_policy.infra_deployment_role_policy.arn
}

resource "aws_iam_user" "infra_deployment_user" {
  name = "${var.project_name}-infra-deploy-user"
}

resource "aws_iam_policy" "infra_deployment_user_policy" {
  name        = "${var.project_name}-infra-deploy-user-policy"
  description = "Policy to allow user to assume a role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = aws_iam_role.infra_deployment_role.arn
      },
    ]
  })
}

resource "aws_iam_user_policy_attachment" "infra_user_assume_role_policy_attachment" {
  user       = aws_iam_user.infra_deployment_user.name
  policy_arn = aws_iam_policy.infra_deployment_user_policy.arn
}

