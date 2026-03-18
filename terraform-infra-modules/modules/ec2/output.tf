output "ec2_instance_public_ippp" {
  value = aws_instance.aws_modular.public_ip
}

output "ec2_instance_public_dns" {
  value = aws_instance.aws_modular.public_dns
}
