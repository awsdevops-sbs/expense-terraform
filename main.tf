module "frontend" {
  depends_on = [module.backend]
  source        = "./modules/app"
  component     = "frontend"
  instance_type = var.instance_type
  vault_token   = var.vault_token
  env           = var.env
  zone_id       = var.zone_id
  subnets       = module.vpc.frontend_subnet
  vpc_id            = module.vpc.vpc_id
  lb_type           = "public"
  lb_needed         = "true"
  lb_subnets        = module.vpc.public_subnet
  app_port          = 80
  server_app_port_sg_cidr = var.public_subnet
  lb_app_port_sg_cidr = ["0.0.0.0/0"]
  bastion_nodes    = var.bastion_nodes
  prometheus_nodes = var.prometheus_nodes
}
#
module "backend" {
  depends_on = [module.mysql]
  source      = "./modules/app"
  component = "backend"
  instance_type = var.instance_type
  vault_token   = var.vault_token
  env = var.env
  subnets = module.vpc.backend_subnet
  vpc_id = module.vpc.vpc_id
  zone_id = var.zone_id
  lb_type = "private"
  lb_needed = "true"
  lb_subnets = module.vpc.backend_subnet
  app_port = 8080
  server_app_port_sg_cidr = concat(var.frontend_subnet,var.backend_subnet)
  bastion_nodes    = var.bastion_nodes
  prometheus_nodes = var.prometheus_nodes
  lb_app_port_sg_cidr = var.frontend_subnet
}

module "mysql" {
  source = "./modules/app"
  component = "mysql"
  instance_type = var.instance_type
  env = var.env
  vault_token   = var.vault_token
  zone_id = var.zone_id
  subnets = module.vpc.db_subnet
  vpc_id = module.vpc.vpc_id
  #public_subnet = module.vpc.public_subnet
  lb_needed = "false"
  app_port = 3306
  server_app_port_sg_cidr = var.backend_subnet
  bastion_nodes    = var.bastion_nodes
  prometheus_nodes = var.prometheus_nodes

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
  public_subnet = var.public_subnet
  availability_zone = var.availability_zone

}