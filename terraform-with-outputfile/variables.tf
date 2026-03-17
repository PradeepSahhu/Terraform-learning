

variable "ami" {
  default     = "ami-0b6c6ebed2801a5cb"
  description = "AWS AMI unique ID"

}

variable "instance_type" {
  default     = "t2.micro"
  description = "the type of the instance micro, etc."
}

variable "key_name" {
  default     = "terraform-key-pair"
  description = "the name of the key pair to use for SSH access to the instance"
}

variable "security_group" {
  default     = "terraform-security-group"
  description = "the name of the security group to associate with the instance"
}