resource "aws_instance" "bastion_host_ec2" {
  ami           = var.ami_id
  instance_type = "t4g.nano"
  # todo must be an exiting key
  key_name                    = "${var.project_prefix}-bastion-host-key"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.bastion_host_ec2_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.bastion_host.name
  disable_api_termination     = terraform.workspace == "prod" ? true : false

  root_block_device {
    volume_size           = 16
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true

    tags = {
      Name = "${var.project_prefix}-bastion-host-vol"
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # Enforces IMDSv2
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  user_data = <<-EOF
    #!/bin/bash
    set -e
    sudo apt update -y
    sudo apt install -y postgresql-client
    sudo apt clean
    sudo snap install aws-cli --classic
  EOF

  tags = {
    Name = "${var.project_prefix}-bastion-host-ec2"
  }
}
