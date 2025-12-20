resource "random_password" "synapse_db_password" {
  length  = 32
  special = true
}

resource "random_password" "turn_shared_secret" {
  length  = 32
  special = false
}

resource "aws_ssm_parameter" "synapse_db_password" {
  name  = "${var.ssm_param_path}/SYNAPSE_DB_PASSWORD"
  type  = "SecureString"
  value = random_password.synapse_db_password.result

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_ssm_parameter" "turn_shared_secret" {
  name  = "${var.ssm_param_path}/TURN_SHARED_SECRET"
  type  = "SecureString"
  value = random_password.turn_shared_secret.result

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_ssm_document" "matrix_homeline_deploy" {
  name            = var.ssm_deploy_command
  document_type   = "Command"
  document_format = "YAML"

  content = <<-YAML
${file("${path.module}/ssm/run-git-deploy.yaml")}
YAML
}
