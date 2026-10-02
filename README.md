# Terraform Modules – Hands-on

This project covers creating a reusable Terraform VPC module and using the same module for multiple VPCs.

## Prerequisites
Run this on an Amazon Linux EC2 instance.

Install Git, Terraform and AWS CLI:

sudo dnf update -y,

sudo dnf install git awscli tree -y,

sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo,

sudo dnf -y install terraform

Verify:

git --version

terraform --version

aws --version


For AWS access, attach an IAM role to the EC2 instance with the required permissions and verify:

aws sts get-caller-identity

Configure GitHub SSH access, then clone the repository:


git clone git@github.com:<USERNAME>/terraform-modules-project.git

cd terraform-modules-project


## 1. Create the VPC module

Create the module directory:

mkdir -p modules/vpc

'modules/vpc/main.tf

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

modules/vpc/variables.tf`

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}


modules/vpc/outputs.tf`
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}


The module is reusable because the CIDR and VPC name are passed as variables.

## 2. Use the module

main.tf`
provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = "10.0.0.0/16"
  vpc_name = "Dev-VPC"
}

module "prod_vpc" {
  source = "./modules/vpc"

  vpc_cidr = "10.1.0.0/16"
  vpc_name = "Prod-VPC"
}

outputs.tf
output "dev_vpc_id" {
  value = module.vpc.vpc_id
}

output "prod_vpc_id" {
  value = module.prod_vpc.vpc_id
}


source = "./modules/vpc"` tells Terraform to use the module from the local modules/vpc directory.

The same module is used twice with different values.

## 3. Run Terraform

Initialize:

terraform init

Format and validate:

terraform fmt

terraform validate

Check what Terraform will change:

terraform plan

Apply only after reviewing the plan:

terraform apply

Enter `yes` when prompted.

Check the outputs:

terraform output

Check the resources managed by Terraform:

terraform state list

Expected resources:

module.vpc.aws_vpc.this

module.prod_vpc.aws_vpc.this

## 4. GitHub

Check the changes:

git status

Commit and push:

git add .

git commit -m "Reuse VPC module for dev and prod"

git push origin main

## Important Terraform note

Terraform tracks resources using their addresses. For example:


module.vpc.aws_vpc.this

If `module.vpc` is renamed to `module.dev_vpc`, Terraform can see it as a different resource and may plan to destroy the old resource and create a new one.

Always check `terraform plan` before `terraform apply`, especially when changing module or resource names.

## Useful commands


terraform init       # Initialize Terraform

terraform fmt        # Format code

terraform validate   # Validate configuration

terraform plan       # Preview changes

terraform apply      # Create/update resources

terraform output     # Show outputs

terraform state list # Show managed resources

terraform destroy    # Remove managed resources


## What this project demonstrates

A reusable module lets us write the VPC logic once and reuse it for different environments such as Dev, QA and Prod by passing different variables.

Next topics: Public Modules → Terraform Registry → Workspaces → Remote Backend → State Management → Secrets Management.
