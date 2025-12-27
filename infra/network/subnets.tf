data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "project_subnet_public" {
  count                   = 2
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block = cidrsubnet(aws_vpc.project_vpc.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.project_prefix}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "project_subnet_private" {
  count                   = 2
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block = cidrsubnet(aws_vpc.project_vpc.cidr_block, 8, count.index + length(data.aws_availability_zones.available.names))
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.project_prefix}-private-subnet-${count.index + 1}"
  }
}

output "public_subnets_ids" {
  value       = aws_subnet.project_subnet_public[*].id
  description = "IDs of the Public subnets"
}

output "private_subnets_ids" {
  value       = aws_subnet.project_subnet_private[*].id
  description = "IDs of the private subnets"
}