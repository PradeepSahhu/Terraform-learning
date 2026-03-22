# Terraform-learning

Learning Terraform with AWS

what is terraform?

Terraform is an open-source infrastructure as code software tool created by HashiCorp. It allows users to define and provision data center infrastructure using a high-level configuration language known as HashiCorp Configuration Language (HCL), or optionally JSON. Terraform enables you to manage and version your infrastructure in a safe and efficient manner, making it easier to automate the provisioning and management of resources across various cloud providers and services. (aws, azure, google cloud, etc) single file for all different providers. (ec2 - aws, compute engine - google cloud, etc)

### Install Terraform

Using the brew as the package manager, you can install Terraform with the following command:

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

#### Check if its really installed:

```bash
terraform -v
or
terraform version
```

###### How will the terraform knows who i am and if i am allowed to create the resources on Cloud provider like aws(ec2, s3), azure(vm, storage), gcp etc.?

I need to provide the credentials to terraform, so it can authenticate and authorize my actions on the cloud provider. This is typically done by setting environment variables or using a configuration file that contains the necessary credentials.

For example, if we are using AWS, you can set the following environment variables:

```bash
export AWS_ACCESS_KEY_ID=your_access_key_id
export AWS_SECRET_ACCESS_KEY=your_secret_access_key
```

Alternatively, we can use the AWS CLI to configure our credentials, which will create a configuration file that Terraform can use:

```bash
aws configure
```

In Terraform we use the language called HCL (HashiCorp Configuration Language) to define our infrastructure. We can create a file with a .tf extension (e.g., main.tf) and write our infrastructure code in it.

#### Example of a simple Terraform configuration to create an AWS EC2 instance:

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleInstance"
  }
}
```

the access_key_id and secret_access_key will be automatically picked up from the environment variables we set earlier, so we don't need to include them in our configuration file, which is a best practice for security reasons.

#### Start Execution (commands)

1. Initialize the Terraform working directory:

![alt text](images/image.png)

```bash
terraform init
```

what it does: It initializes the Terraform working directory, which includes downloading the necessary provider plugins and setting up the backend for storing state.

Always good to run terraform fmt and terraform validate before terraform init, to make sure there are no syntax errors in the configuration files.

and also terraform fmt - to format the code in a consistent way, and terraform validate - to check for any syntax errors or issues in the configuration files.

terraform validate - to check for any syntax errors or issues in the configuration files.

2. Plan the changes:

```bash
terraform plan
```

what it does: It creates an execution plan, which shows you what actions Terraform will take to achieve the desired state defined in your configuration files. It allows you to review the changes before applying them.

to destroy the infrastructure, we can use the command:

```bash
terraform destroy --auto-approve
```

![alt text](images/image3.png)
why --auto-approve?

The --auto-approve flag is used with the terraform destroy command to bypass the confirmation prompt that typically appears before destroying infrastructure. When you run terraform destroy, it will ask for confirmation to ensure that you really want to proceed with the destruction of resources. By using --auto-approve, you are telling Terraform to skip this confirmation step and proceed with the destruction immediately. This can be useful in automated scripts or when you are certain that you want to destroy the resources without needing an additional confirmation. However, it should be used with caution, as it can lead to unintended consequences if used in the wrong context.

3. Apply the changes:

```bash
terraform apply
```

![alt text](images/image2.png)

#### Terraform State

(terraform.tfstate & terraform.tfstate.backup)
Terraform state is a critical component of Terraform's infrastructure management. It is a file that Terraform uses to keep track of the resources it manages and their current state. The state file contains information about the resources that have been created, updated, or deleted by Terraform, as well as their attributes and dependencies.
The state file is typically stored locally on the machine where Terraform is run, but it can also be stored remotely in a backend such as Amazon S3, Azure Blob Storage, or HashiCorp Consul. The state file is essential for Terraform to function properly, as it allows Terraform to determine what changes need to be made to the infrastructure when you run terraform apply.
The state file is also used to track the dependencies between resources, which allows Terraform to create and manage resources in the correct order. For example, if you have a resource that depends on another resource, Terraform will ensure that the dependent resource is created before the resource that depends on it.
It is important to manage the state file carefully, as it contains sensitive information about your infrastructure and can be a target for attackers. It is recommended to use a secure backend for storing the state file and to restrict access to it to only those who need it. Additionally, it is important to regularly back up the state file to prevent data loss in case of accidental deletion or corruption.

## Terraform taint for aws_instance.aliasname

The command below marks one specific resource in state as tainted:

```bash
terraform taint aws_instance.aliasname
```

In this format:

- aws_instance is the resource type
- aliasname is the local resource name from your Terraform code

Example:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxxxxxxxxxxx"
  instance_type = "t2.micro"
}
```

For this resource, the taint command is:

```bash
terraform taint aws_instance.web
```

What it does:

- Updates Terraform state and marks only that resource as damaged or dirty
- Does not immediately recreate anything
- On the next terraform plan or terraform apply, Terraform proposes destroy and recreate for that resource

How it works step by step:

1. You run terraform taint on a specific resource address.
2. Terraform writes a tainted flag in state for that address.
3. During plan/apply, Terraform sees the tainted object and schedules replacement.
4. Apply performs replacement and then clears the tainted state.

When to use it:

- Instance is reachable in cloud but unhealthy or misconfigured
- Manual changes were made outside Terraform and you want a clean rebuild
- Bootstrapping scripts failed and you want to force re-provisioning

Important note:

- terraform taint is deprecated in newer workflows.
- Preferred modern approach is:

```bash
terraform apply -replace="aws_instance.web"
```

The replace option is safer because replacement intent is explicit in the same apply command and easier to review in team workflows.

## Seperation of concerns

In Terraform, separation of concerns is a design principle that encourages the organization of infrastructure code into modular and reusable components. This approach helps to improve the maintainability, readability, and scalability of your Terraform configurations.

- Variable.tf : This file is used to define input variables that can be used throughout your Terraform configuration. It allows you to parameterize your infrastructure code, making it more flexible and reusable.

example of variable.tf

```hcl
variable "instance_type" {
  description = "The type of instance to create"
  type        = string
  default     = "t2.micro"
}
```

- main.tf : This file is typically used to define the main resources and infrastructure components that you want to create or manage. It contains the core logic of your Terraform configuration.

example of main.tf

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type # using the variable defined in variable.tf "${var.instance_type}"
    tags = {
        Name = "ExampleInstance"
    }
}
```

- providers.tf : This file is used to specify the providers that Terraform will use to interact with the cloud platforms or services. It defines the provider configurations, such as authentication credentials and region settings.

example of providers.tf

`````hcl
provider "aws" {
    region = "us-east-1"
    }
    ````

`````

- outputs.tf : This file is used to define output values that can be used to display information about the resources created by Terraform. It allows you to extract and display specific attributes of your infrastructure after it has been provisioned.

## Repository folder overview (what each project does)

This repo has multiple Terraform practice projects. Each folder can be executed independently.

### 1) terraform-ec2

Purpose:

- Provision one Ubuntu EC2 instance in `us-east-1`.

Highlights:

- Uses `t2.micro`
- Uses key pair: `terraform-key-pair`
- Uses security group: `terraform-security-group`

Run:

```bash
cd terraform-ec2
terraform fmt
terraform validate
terraform init
terraform plan
terraform apply
```

Destroy:

```bash
terraform destroy --auto-approve
```

### 2) terraform-ec2-static-website

Purpose:

- Provision EC2 and configure a static web page using user data script.

Highlights:

- Uses `setupstaticwebsite.sh`
- Installs Apache (`apache2`)
- Creates `/var/www/html/index.html` with sample content

Run:

```bash
cd terraform-ec2-static-website
terraform fmt
terraform validate
terraform init
terraform plan
terraform apply
```

Destroy:

```bash
terraform destroy --auto-approve
```

### 3) terraform-provision-s3-bucket

Purpose:

- Provision a secure S3 bucket with production-like safety defaults.

Highlights:

- Bucket creation
- Versioning enabled
- Public access block enabled
- Server-side encryption (`AES256`)
- Lifecycle rule for old object versions

Important:

- S3 bucket name must be globally unique. Update bucket name before apply.

Run:

```bash
cd terraform-provision-s3-bucket
terraform fmt
terraform validate
terraform init
terraform plan
terraform apply
```

Destroy:

```bash
terraform destroy --auto-approve
```

### 4) terraform-with-seperation-of-concerns

Purpose:

- Demonstrates Terraform file separation pattern.

Structure:

- `provider.tf` -> provider config
- `variables.tf` -> variable declarations
- `main.tf` -> resource definitions

Run:

```bash
cd terraform-with-seperation-of-concerns
terraform fmt
terraform validate
terraform init
terraform plan
terraform apply
```

Destroy:

```bash
terraform destroy --auto-approve
```

### 5) terraform-with-outputfile

Purpose:

- Demonstrates Terraform output values after provisioning EC2.

Outputs exposed:

- instance public IP
- instance public DNS
- instance ID
- instance ARN
- instance availability zone
- instance tags

Run:

```bash
cd terraform-with-outputfile
terraform fmt
terraform validate
terraform init
terraform plan
terraform apply
terraform output
```

Destroy:

```bash
terraform destroy --auto-approve
```

### 6) terraform-infra-modules

Purpose:

- Demonstrates reusable modules approach.

Structure:

- `modules/ec2` -> EC2 module
- `modules/s3` -> S3 module
- root module calls both modules

Run:

```bash
cd terraform-infra-modules
terraform fmt
terraform validate
terraform init
terraform plan
terraform apply
terraform output
```

Destroy:

```bash
terraform destroy --auto-approve
```

## Useful Terraform commands you can add to daily workflow

```bash
terraform fmt -recursive
terraform validate
terraform show
terraform state list
terraform output
```

## Variable override examples

You can override defaults using `-var`:

```bash
terraform apply \
  -var="ami=ami-xxxxxxxxxxxxxxxxx" \
  -var="instance_type=t3.micro" \
  -var="key_name=my-keypair"
```

Or with `terraform.tfvars`:

```hcl
ami           = "ami-xxxxxxxxxxxxxxxxx"
instance_type = "t2.micro"
key_name      = "terraform-key-pair"
```

## Common issues and fixes

1. InvalidKeyPair.NotFound

- Key pair does not exist in selected region. Create/import the key pair in `us-east-1`.

2. Security group not found

- Ensure `terraform-security-group` exists or update config with your actual security group.

3. BucketAlreadyExists or BucketAlreadyOwnedByYou

- Update bucket name to a globally unique value.

4. AccessDenied

- Check IAM user/role policy for EC2/S3 permissions.

5. Provider plugin issues

- Run `terraform init -upgrade`.

## Best practices for this repo

- Run one folder at a time (each folder keeps its own state).
- Always run `terraform plan` before `terraform apply`.
- Destroy resources after practice to avoid AWS charges.
- Avoid hardcoding secrets in `.tf` files.
- Keep state files out of Git by using `.gitignore`.

## Good next step (optional enhancement)

- Add `versions.tf` in each folder to pin Terraform and AWS provider versions.
- Add remote state backend (S3 + DynamoDB lock table) for team usage.
- Replace hardcoded security group references with variables everywhere.
