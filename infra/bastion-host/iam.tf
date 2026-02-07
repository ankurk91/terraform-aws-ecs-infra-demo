# IAM Role for EC2 Instance
resource "aws_iam_role" "bastion_host" {
  name = "${var.project_prefix}-bastion-host-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_prefix}-bastion-host-ec2-role"
  }
}

# Attach CloudWatchAgentServerPolicy
resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.bastion_host.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Attach AmazonSSMManagedInstanceCore
resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
  role       = aws_iam_role.bastion_host.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "bastion_host" {
  name = "${var.project_prefix}-bastion-host-ec2-profile"
  role = aws_iam_role.bastion_host.name

  tags = {
    Name = "${var.project_prefix}-bastion-host-ec2-profile"
  }
}
