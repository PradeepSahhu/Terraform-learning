provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ubuntu-ec2-VM" {

  ami             = "ami-0b6c6ebed2801a5cb"
  instance_type   = "t2.micro"
  key_name        = "terraform-key-pair"
  security_groups = ["terraform-security-group"]
  tags = {
    Name = "Terraform_ubuntu"
  }
}