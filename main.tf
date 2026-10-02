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
