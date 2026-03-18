

variable "ami" {
  type        = string
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
