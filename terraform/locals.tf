locals {
  mounts_bash = join("\n", [
    for _, v in var.matrix_volumes :
    "MOUNTS[\"${v.device_name}\"]=\"${v.mount_path}\""
  ])

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    mounts_bash = local.mounts_bash
  })
}
