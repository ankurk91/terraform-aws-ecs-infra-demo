locals {
  ecs_task_config = {
    dev = {
      CPU    = 256
      MEMORY = 512
    }
    staging = {
      CPU    = 256
      MEMORY = 512
    }
    prod = {
      CPU    = 1024
      MEMORY = 2048
    }
  }

  # Default configuration for undefined workspaces
  default_ecs_config = {
    CPU    = 256
    MEMORY = 512
  }
  current_ecs_config = lookup(local.ecs_task_config, terraform.workspace, local.default_ecs_config)

  TASK_CPU = local.current_ecs_config.CPU # CPU in CPU units (e.g., 256 = 0.25 vCPU)
  TASK_MEMORY = local.current_ecs_config.MEMORY  # Memory in MB
  CPU_ARCHITECTURE = "X86_64" # or ARM64
}

resource "aws_cloudwatch_log_group" "backend_ecs_service_log_group" {
  name              = "/ecs/${var.project_prefix}/backend-service"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "backend_ecs_task_definition" {
  family             = "${var.project_prefix}-backend-service"
  execution_role_arn = aws_iam_role.backend_ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.backend_ecs_task_role.arn
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                = local.TASK_CPU
  memory             = local.TASK_MEMORY
  track_latest       = true

  runtime_platform {
    cpu_architecture = local.CPU_ARCHITECTURE
  }

  container_definitions = jsonencode([
    {
      name         = local.containerName
      image        = "${aws_ecr_repository.backend_ecr_repo.repository_url}:latest"
      essential    = true
      network_mode = "awsvpc"
      cpu          = local.TASK_CPU
      memory       = local.TASK_MEMORY
      stopTimeout = 30

      portMappings = [
        {
          containerPort = local.containerPort
          hostPort      = local.containerPort
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.backend_ecs_service_log_group.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }

      healthCheck = {
        "command" : ["CMD", "curl", "-f", "http://127.0.0.1:${var.app_container_port}/"]
        "interval"    = 30
        "timeout"     = 5
        "retries"     = 1
        "startPeriod" = 5
      }
      mountPoints = [],
      volumesFrom = [],
      systemControls = [],
      volumes = [],
      enableFaultInjection = false,
      placementConstraints = false,
      environment = [
        {
          name  = "NODE_ENV"
          value = terraform.workspace == "prod" ? "production" : "development"
        },
        {
          name = "APP_PORT"
          value = tostring(local.containerPort)
        },
        {
          name = "AWS_REGION"
          value = var.aws_region
        },
        {
          name = "AWS_SES_CONFIGURATION_SET"
          value = "${var.project_prefix}-configuration-set"
        },
        {
          name = "AWS_BUCKET_NAME"
          value = aws_s3_bucket.backend_s3_bucket.bucket
        },
        {
          name = "REDIS_PORT"
          value = "6379"
        }
      ],

      secrets : [
        {
          name = "AUTH_API_BASE_URL"
          valueFrom = "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter${aws_ssm_parameter.backend_app_ssm_auth_api_base_url.name}"
        },
        {
          name       = "JWT_PUBLIC_KEY"
          valueFrom = "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter${aws_ssm_parameter.backend_app_ssm_jwt_public_key.name}"
        },
        {
          name       = "DATABASE_URL"
          valueFrom = "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter${aws_ssm_parameter.backend_app_ssm_database_url.name}"
        },
        {
          name = "REDIS_HOST"
          valueFrom = "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter${aws_ssm_parameter.backend_app_redis_host.name}"
        },
        {
          name = "CLIENT_ID"
          valueFrom = "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter${aws_ssm_parameter.backend_app_ssm_client_id.name}"
        },
        {
          name = "CLIENT_SECRET"
          valueFrom = "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter${aws_ssm_parameter.backend_app_ssm_client_secret.name}"
        },
        {
          name = "CLIENT_REDIRECT_URI"
          valueFrom = "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter${aws_ssm_parameter.backend_app_ssm_client_redirect_uri.name}"
        },
        {
          name = "CLIENT_REDIRECT_URI_USER"
          valueFrom = "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter${aws_ssm_parameter.backend_app_ssm_client_redirect_uri_user.name}"
        },
        {
          name="FIREBASE_SERVICE_ACCOUNT_KEY"
          valueFrom = "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter${aws_ssm_parameter.backend_app_ssm_firebase_service_account_key.name}"
        },
        {
          name="AWS_S3_CDN_URL"
          valueFrom = "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter${aws_ssm_parameter.backend_app_ssm_aws_s3_cdn_url.name}"
        }
      ]
    }
  ])
}
