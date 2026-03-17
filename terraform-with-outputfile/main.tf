


resource "aws_instance" "aws_modular_output" {

  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = ["terraform-security-group"]
  tags = {
    Name = "Terraform_Modular_Output"
  }
}