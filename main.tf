# module "frontend" {
#   depends_on = [module.backend]
#   source        = "./modules/app"
#   component     = "frontend"
#   instance_type = var.instance_type
#   vault_token   = var.vault_token
#   env           = var.env
#   zone_id = var.zone_id
# }
#
# module "backend" {
#   depends_on = [module.mysql]
#   source = "./modules/app"
#   component = "backend"
#   instance_type = var.instance_type
#   vault_token   = var.vault_token
#   env = var.env
#
#
#   zone_id = var.zone_id
# }
module "mysql" {
  source = "./modules/app"
  component = "mysql"
  instance_type = var.instance_type
  env = var.env
  vault_token   = var.vault_token
  zone_id = var.zone_id
}

module "vpc" {
  source = "./modules/vpc"
  env    = var.env
  vpc_cidr_block = var.vpc_cidr_block
  #subnet_cidr_block = var.subnet_cidr_block
  default_vpc_id = var.default_vpc_id
  default_cidr_block = var.default_cidr_block
  default_route_id = var.default_route_id
  frontend_subnet = var.frontend_subnet
  backend_subnet = var.backend_subnet
  db_subnet = var.db_subnet
  availability_zone = var.availability_zone


}