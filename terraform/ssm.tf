resource "random_password" "synapse_db_password" {
  length  = 32
  special = true
}

resource "random_password" "turn_shared_secret" {
  length  = 32
  special = false
}

resource "aws_ssm_parameter" "synapse_db_password" {
  name  = "/matrix-homeline/prod/SYNAPSE_DB_PASSWORD"
  type  = "SecureString"
  value = random_password.synapse_db_password.result

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_ssm_parameter" "turn_shared_secret" {
  name  = "/matrix-homeline/prod/TURN_SHARED_SECRET"
  type  = "SecureString"
  value = random_password.turn_shared_secret.result

  # lifecycle {
  #   prevent_destroy = true
  # }
}
