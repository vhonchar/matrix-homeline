########################################
# Networking
########################################

resource "aws_security_group" "matrix" {
  name_prefix = "matrix-sg-"
  description = "Matrix Synapse, Element, and LiveKit ports"
  vpc_id      = data.aws_vpc.default.id

  lifecycle {
    create_before_destroy = true
  }

  # --- Web & Matrix Client ---
  ingress {
    description = "HTTP/HTTPS for Nginx"
    from_port   = 80
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Matrix Federation"
    from_port   = 8448
    to_port     = 8448
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # --- LiveKit Media ---
  ingress {
    description = "LiveKit Signal Fallback"
    from_port   = 7881
    to_port     = 7881
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "LiveKit UDP Media (Match your Docker Compose)"
    from_port   = 50000
    to_port     = 50500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # --- Coturn (TURN/STUN) ---
  ingress {
    description = "STUN/TURN Signaling"
    from_port   = 3478
    to_port     = 3478
    protocol    = "tcp" # Add a separate one for protocol = "udp" if needed
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "STUN/TURN Signaling UDP"
    from_port   = 3478
    to_port     = 3478
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Coturn Relay Range"
    from_port   = 49152
    to_port     = 65535
    protocol    = "udp"
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

  subnet_id = local.selected_subnet_id

  vpc_security_group_ids      = [aws_security_group.matrix.id]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_profile.name

  user_data = local.user_data
  user_data_replace_on_change = true

  tags = {
    Name = var.instance_name
  }
}
