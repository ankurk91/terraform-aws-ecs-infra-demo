resource "aws_ecr_repository" "backend_ecr_repo" {
  name         = "${var.project_prefix}-backend-ecr-repo"
  force_delete = true

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_ecr_lifecycle_policy" "backend_ecr_lifecycle_policy" {
  repository = aws_ecr_repository.backend_ecr_repo.name

  policy = jsonencode({
    "rules" = [
      {
        "rulePriority" = 1
        "description"  = "Retain only the last 10 images"
        "selection" = {
          "tagStatus"   = "any"
          "countType"   = "imageCountMoreThan"
          "countNumber" = 10
        }
        "action" = {
          "type" = "expire"
        }
      }
    ]
  })
}
