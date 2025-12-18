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
