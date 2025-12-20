data "aws_subnet" "selected" {
  id = local.selected_subnet_id
}

resource "aws_ebs_volume" "matrix_data" {
  availability_zone = data.aws_subnet.selected.availability_zone
  type              = "gp3"
  size              = var.matrix_data_volume.size_gb
  encrypted         = true

  tags = {
    Name = "${var.instance_name}-data"
    App  = "matrix-homeline"
  }

  lifecycle { prevent_destroy = false }
}

resource "aws_volume_attachment" "matrix_data" {
  device_name = var.matrix_data_volume.device_name
  volume_id   = aws_ebs_volume.matrix_data.id
  instance_id = aws_instance.matrix.id

  force_detach = true

  lifecycle {
    replace_triggered_by = [aws_instance.matrix.id]
  }
}