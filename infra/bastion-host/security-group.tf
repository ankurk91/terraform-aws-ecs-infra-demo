resource "aws_security_group" "bastion_host_ec2_sg" {
  name        = "${var.project_prefix}-bastion-host-sg"
  description = "Allow SSH traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_prefix}-bastion-host-sg"
  }
}
