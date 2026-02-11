variable "aws_region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "eu-central-1"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for Matrix/Element host"
  default     = "t3.small"
}

variable "instance_name" {
  type        = string
  description = "Tag Name for the EC2 instance"
  default     = "matrix-homeserver"
}

variable "ssm_param_path" {
  description = "Path to store the SSM parameter in"
  type        = string
  default     = "/matrix-homeline/prod"
}

variable "ssm_deploy_command" {
  description = "SSM document name to use for deployment of this repo"
  type        = string
  default     = "matrix-homeline-deploy"
}

variable "matrix_data_volume" {
  type = object({
    size_gb     = number
    device_name = string
    mount_path  = string
  })
  default = {
    size_gb     = 100
    device_name = "/dev/sdf"
    mount_path  = "/srv/matrix"
  }
}

variable "porkbun_api_key" {
  description = "Porkbun API key to store in SSM"
  type        = string
}

variable "porkbun_api_secrete_key" {
  description = "Porkbun API Secrete key to store in SSM"
  type        = string
}

variable "acme_email" {
  description = "Email to use in acme"
  type        = string
}
