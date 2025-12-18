locals {
  # user_data.sh.tpl takes no variables now
  user_data = templatefile("user_data.sh.tftpl", {
    mounts_bash = join("\n", [
      for k, v in var.matrix_volumes :
      "MOUNTS[\"${v.device_name}\"]=\"${v.mount_path}\""
    ])
  })
}