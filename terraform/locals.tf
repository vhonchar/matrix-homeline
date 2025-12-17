locals {
  # user_data.sh.tpl takes no variables now
  user_data = templatefile("${path.module}/user_data.sh.tpl", {})
}