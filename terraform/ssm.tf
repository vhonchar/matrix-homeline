locals {
  secrets = {
    POSTGRES_PASSWORD          = { length = 32, special = true }
    MACAROON_SECRET_KEY        = { length = 64, special = true }
    REGISTRATION_SHARED_SECRET = { length = 64, special = true }
    TURN_SHARED_SECRET         = { length = 64, special = true }
  }
}

resource "random_password" "generated" {
  for_each = local.secrets

  length  = each.value.length
  special = each.value.special
}

resource "aws_ssm_parameter" "secrets" {
  for_each = local.secrets

  name  = "${var.ssm_param_path}/${each.key}"
  type  = "SecureString"
  value = random_password.generated[each.key].result

  lifecycle {
    # prevent_destroy = true
  }
}

resource "aws_ssm_document" "matrix_homeline_deploy" {
  name            = var.ssm_deploy_command
  document_type   = "Command"
  document_format = "YAML"

  content = <<-YAML
${file("${path.module}/ssm/run-git-deploy.yaml")}
YAML
}

resource "aws_ssm_parameter" "porkbun_api_key" {
  name  = "${var.ssm_param_path}/PORKBUN_API_KEY"
  type  = "SecureString"
  value = var.porkbun_api_key
}

resource "aws_ssm_parameter" "porkbun_api_private_key" {
  name  = "${var.ssm_param_path}/PORKBUN_API_PRIVATE_KEY"
  type  = "SecureString"
  value = var.porkbun_api_private_key
}
