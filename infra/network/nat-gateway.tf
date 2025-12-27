resource "aws_eip" "project_nat_eip" {
  instance = null

  tags = {
    Name = "${var.project_prefix}-nat-gateway-eip"
  }
}

resource "aws_nat_gateway" "project_nat_gateway" {
  allocation_id = aws_eip.project_nat_eip.id
  subnet_id     = aws_subnet.project_subnet_public[0].id

  tags = {
    Name = "${var.project_prefix}-nat-gateway"
  }
}

output "nat_gateway_public_ip" {
  value = aws_nat_gateway.project_nat_gateway.public_ip
}
