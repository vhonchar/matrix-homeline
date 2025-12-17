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

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR allowed to SSH into the instance"
  default     = "0.0.0.0/0" # tighten to your IP later
}

# Optional: if you already have an AWS key pair you want to use for SSH
variable "ssh_key_name" {
  type        = string
  description = "Existing AWS key pair name to attach for SSH access"
  default     = ""
}
