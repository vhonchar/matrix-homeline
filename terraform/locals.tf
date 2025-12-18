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
  mounts_bash = join("\n", [
    for _, v in var.matrix_volumes :
    "MOUNTS[\"${v.device_name}\"]=\"${v.mount_path}\""
  ])

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    mounts_bash = local.mounts_bash
  })
}
