module "complte_infra_ec2" {
  source = "./modules/ec2"
  ami    = "ami-0b6c6ebed2801a5cb"
}

module "complete_infra_s3" {
  source = "./modules/s3"
}

