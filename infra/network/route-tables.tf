resource "aws_route_table" "project_public_route_table" {
  vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project_igw.id
  }

  tags = {
    Name = "${var.project_prefix}-public-route-table"
  }
}

resource "aws_route_table_association" "project_public_route_table_assoc" {
  count          = 2
  subnet_id      = aws_subnet.project_subnet_public[count.index].id
  route_table_id = aws_route_table.project_public_route_table.id
}

resource "aws_route_table" "project_private_route_table" {
  vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.project_nat_gateway.id
  }

  tags = {
    Name = "${var.project_prefix}-private-route-table"
  }
}

resource "aws_route_table_association" "project_private_route_table_assoc" {
  count          = 2
  subnet_id      = aws_subnet.project_subnet_private[count.index].id
  route_table_id = aws_route_table.project_private_route_table.id
}

