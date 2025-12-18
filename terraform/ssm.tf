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

resource "aws_ssm_document" "matrix_homeline_launcher" {
  name          = "${var.instance_name}-launcher"
  document_type = "Command"

  content = templatefile("${path.module}/ssm/matrix-homeline-deploy.json.tftpl", {
    app_dir    = var.app_dir
    repo_url   = var.repo_url
    param_path = "${var.ssm_param_path}/"
  })
}

