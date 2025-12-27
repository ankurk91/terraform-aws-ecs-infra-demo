resource "aws_instance" "bastion_host_ec2" {
  ami                         = var.ami_id
  instance_type = "t4g.nano"
  # todo must be an exiting key
  key_name                    = "${var.project_prefix}-bastion-host-key"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.bastion_host_ec2_sg.id]
  associate_public_ip_address = true

  ebs_block_device {
    device_name           = "/dev/sda1"
    volume_size           = 8
    volume_type           = "gp3"
    delete_on_termination = true

    tags = {
      Name = "${var.project_prefix}-bastion-host-vol"
    }
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y postgresql-client
    sudo apt clean
    sudo snap install aws-cli --classic
  EOF

  tags = {
    Name = "${var.project_prefix}-bastion-host-ec2"
  }
}
