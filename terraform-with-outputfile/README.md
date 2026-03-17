# Terraform with Output File

This folder contains a Terraform configuration that provisions one AWS EC2 instance and exposes key instance details using Terraform outputs.

## What Is Implemented

- AWS provider configured for region `us-east-1`
- One EC2 instance resource: `aws_instance.aws_modular_output`
- Configurable input variables for:
  - AMI ID
  - Instance type
  - Key pair name
  - Security group name (defined as a variable)
- Output values for instance metadata (IP, DNS, ID, ARN, AZ, tags)

## Files Overview

- `provider.tf`: Configures AWS provider and target region
- `variables.tf`: Declares all input variables with defaults and descriptions
- `main.tf`: Creates the EC2 instance resource
- `output.tf`: Exposes useful computed attributes after apply

## Inputs

The following variables are defined in `variables.tf`:

- `ami` (default: `ami-0b6c6ebed2801a5cb`)
- `instance_type` (default: `t2.micro`)
- `key_name` (default: `terraform-key-pair`)
- `security_group` (default: `terraform-security-group`)

## Resource Details

Terraform creates:

- `aws_instance.aws_modular_output`
  - `ami = var.ami`
  - `instance_type = var.instance_type`
  - `key_name = var.key_name`
  - `security_groups = ["terraform-security-group"]`
  - Tag: `Name = "Terraform_Modular_Output"`

## Outputs

After `terraform apply`, Terraform returns:

- `ec2_instance_public_ip`
- `ec2_instance_public_dns`
- `ec2_instance_id`
- `ec2_instance_arn`
- `ec2_instance_availability_zone`
- `ec2_instance_tags`

You can also inspect them manually:

```bash
terraform output
```

## How to Run

From this folder:

```bash
terraform init
terraform plan
terraform apply --auto-approve
```

## Optional Variable Override

You can override defaults at runtime:

```bash
terraform apply \
  -var="ami=ami-xxxxxxxxxxxxxxxxx" \
  -var="instance_type=t3.micro" \
  -var="key_name=your-keypair"
```

## Cleanup

To remove the created infrastructure:

```bash
terraform destroy --auto-approve
```

## Notes

- Ensure the AWS key pair (`key_name`) and security group exist in `us-east-1`.
- The EC2 resource currently uses a hardcoded security group name in `main.tf` (`terraform-security-group`) instead of `var.security_group`.
  - If you want the input variable to control this value, update `security_groups` in `main.tf` to use `var.security_group`.
