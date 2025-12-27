resource "aws_eip" "bastion_host_eip" {
  instance = aws_instance.bastion_host_ec2.id

  tags = {
    Name = "${var.project_prefix}-bastion-host-eip"
  }
}
