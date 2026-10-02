output "dev_vpc_id" {
  description = "ID of the development VPC"
  value       = module.vpc.vpc_id
}

output "prod_vpc_id" {
  description = "ID of the production VPC"
  value       = module.prod_vpc.vpc_id
}
