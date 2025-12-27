resource "aws_iam_role" "ecs_service_deployment_role" {
  name = "${var.project_name}-ecs-deploy-assume-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_user.ecs_service_deployment_user.arn
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_service_deployment_role_policy" {
  name        = "${var.project_name}-ecs-deploy-role-policy"
  description = "ECS Service Deployment Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:DescribeClusters",
          "ecs:DescribeTasks",
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:ListTasks",
          "ecs:RegisterTaskDefinition",
          "ecs:UpdateService",
          "ecs:RunTask",
          "ecs:StopTask"
        ]

        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:ListImages"
        ]
        Resource = "*"
      },
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Action = [
          "iam:PassRole"
        ]
        Effect   = "Allow"
        Resource = "*"
        Condition = {
          "StringEqualsIfExists" = {
            "iam:PassedToService" = "ecs-tasks.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_role_policy_attachment" {
  role       = aws_iam_role.ecs_service_deployment_role.name
  policy_arn = aws_iam_policy.ecs_service_deployment_role_policy.arn
}

resource "aws_iam_user" "ecs_service_deployment_user" {
  name = "${var.project_name}-ecs-deploy-user"
}

resource "aws_iam_policy" "ecs_service_deployment_user_policy" {
  name        = "${var.project_name}-ecs-deploy-user-policy"
  description = "Policy to allow user to assume a role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = aws_iam_role.ecs_service_deployment_role.arn
      },
    ]
  })
}

resource "aws_iam_user_policy_attachment" "ecs_user_assume_role_policy_attachment" {
  user       = aws_iam_user.ecs_service_deployment_user.name
  policy_arn = aws_iam_policy.ecs_service_deployment_user_policy.arn
}

