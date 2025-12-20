data "aws_subnet" "selected" {
  id = local.selected_subnet_id
}

resource "aws_ebs_volume" "matrix" {
  for_each = var.matrix_volumes

  availability_zone = data.aws_subnet.selected.availability_zone
  type              = "gp3"
  size              = each.value.size_gb
  encrypted         = true

  tags = {
    Name = "${var.instance_name}-${each.key}"
    App  = "matrix-homeline"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_volume_attachment" "matrix" {
  for_each = var.matrix_volumes

  device_name = each.value.device_name
  volume_id   = aws_ebs_volume.matrix[each.key].id
  instance_id = aws_instance.matrix.id

  force_detach = true

  lifecycle {
    replace_triggered_by = [aws_instance.matrix.id]
  }
}
