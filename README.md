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
