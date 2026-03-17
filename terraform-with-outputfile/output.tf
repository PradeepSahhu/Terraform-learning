output "ec2_instance_public_ip" {
  value = aws_instance.aws_modular_output.public_ip
}

output "ec2_instance_public_dns" {
  value = aws_instance.aws_modular_output.public_dns
}

output "ec2_instance_id" {
  value = aws_instance.aws_modular_output.id
}

output "ec2_instance_arn" {
  value = aws_instance.aws_modular_output.arn
}

output "ec2_instance_availability_zone" {
  value = aws_instance.aws_modular_output.availability_zone
}

output "ec2_instance_tags" {
  value = aws_instance.aws_modular_output.tags
}

