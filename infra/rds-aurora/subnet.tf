data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "rds_private_subnet" {
  count                   = 2
  vpc_id                  = var.vpc_id
  cidr_block = cidrsubnet("10.0.0.0/16", 6, count.index + length(data.aws_availability_zones.available.names))
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.project_prefix}-rds-private-subnet-${count.index + 1}"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "${var.project_prefix}-rds-subnet-group"
  subnet_ids = [
    aws_subnet.rds_private_subnet[0].id,
    aws_subnet.rds_private_subnet[1].id,
  ]
}
