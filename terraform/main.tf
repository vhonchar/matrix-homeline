########################################
# Data sources
########################################

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

########################################
# Networking
########################################

resource "aws_security_group" "matrix" {
  name        = "matrix-sg"
  description = "Allow SSH and HTTP/HTTPS for Matrix/Element host"
  vpc_id      = data.aws_vpc.default.id

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound: allow everything
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########################################
# Compute
########################################

resource "aws_instance" "matrix" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = tolist(data.aws_subnets.default.ids)[0]

  vpc_security_group_ids      = [aws_security_group.matrix.id]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_profile.name

  user_data = local.user_data
  user_data_replace_on_change = true

  tags = {
    Name = var.instance_name
  }
}
