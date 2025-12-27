resource "aws_vpc_endpoint" "s3_vpc_endpoint_gateway" {
  vpc_id            = aws_vpc.project_vpc.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = [aws_route_table.project_private_route_table.id]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:*"
        Resource = "*"
      }
    ]
  })

  tags = {
    Name = "${var.project_prefix}-s3-gateway-endpoint"
  }
}
