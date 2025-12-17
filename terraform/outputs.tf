output "matrix_public_ip" {
  description = "Public IP of the Matrix/Element host"
  value       = aws_instance.matrix.public_ip
}

output "matrix_instance_id" {
  description = "ID of the Matrix/Element EC2 instance"
  value       = aws_instance.matrix.id
}

output "matrix_security_group_id" {
  description = "ID of the security group attached to the instance"
  value       = aws_security_group.matrix.id
}