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

variable "repo_url" {
  description = "Git repository URL to deploy from"
  type        = string
}

variable "app_dir" {
  description = "Directory to clone the repo into"
  type        = string
  default     = "/opt/matrix-homeline"
}

variable "ssm_param_path" {
  description = "Path to store the SSM parameter in"
  type        = string
  default     = "/matrix-homeline/prod"
}

variable "matrix_volumes" {
  description = "EBS volumes for matrix homeline"
  type = map(object({
    size_gb     = number
    device_name = string # e.g. /dev/sdf, /dev/sdg, /dev/sdh
    mount_path  = string # used by user_data
  }))

  default = {
    postgres = { size_gb = 20, device_name = "/dev/sdf", mount_path = "/srv/matrix/postgres" }
    synapse  = { size_gb = 50, device_name = "/dev/sdg", mount_path = "/srv/matrix/synapse" }
    le       = { size_gb = 5, device_name = "/dev/sdh", mount_path = "/srv/matrix/letsencrypt" }
  }
}

