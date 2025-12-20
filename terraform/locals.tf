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

locals {
  selected_subnet_id = sort(data.aws_subnets.default.ids)[0]

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    volume_id  = aws_ebs_volume.matrix_data.id
    mount_path = var.matrix_data_volume.mount_path
    label      = "matrix_data"
    fstype     = "ext4"
  })
}