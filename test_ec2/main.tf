# =============================================================================
# Test resources — recreated from terraform.tfstate
# These resources already exist in AWS
# =============================================================================

data "aws_caller_identity" "current" {}

# ==================== IAM Role for SSM ====================

resource "aws_iam_role" "ssm_role" {
  name = "terraform-test-instance-ssm-role"
  path = "/level3role/"

  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/tabdev-boundary-level3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = { Name = "terraform-test-instance-ssm-role" }
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "terraform-test-instance-ssm-profile"
  path = "/level3role/"
  role = aws_iam_role.ssm_role.name
}

# ==================== Security Group ====================

resource "aws_security_group" "test_sg" {
  name        = "terraform-test-sg"
  description = "Managed by Terraform"
  vpc_id      = "vpc-0e14469ae54111cd7"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.8/32"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.8/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-test-sg"
  }
}

# ==================== EC2 Instance ====================

resource "aws_instance" "test_instance" {
  ami                  = "ami-098341ffb8b768450"
  instance_type        = "t3.micro"
  subnet_id            = "subnet-003601d39ee694be2"
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  vpc_security_group_ids = [aws_security_group.test_sg.id]

  tags = {
    Name = "terraform-test-instance"
  }
}
