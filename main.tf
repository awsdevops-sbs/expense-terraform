module "frontend" {
  source = "./modules/app"
  component = "frontend"
  instance_type = var.instance_type
  env = var.env
  ssh_user = var.ssh_user
  ssh_pass = var.ssh_pass
  zone_id = var.zone_id
}

module "backend" {
  source = "./modules/app"
  component = "backend"
  instance_type = var.instance_type
  env = var.env
  ssh_user = var.ssh_user
  ssh_pass = var.ssh_pass
  zone_id = var.zone_id
}
module "mysql" {
  source = "./modules/app"
  component = "mysql"
  instance_type = var.instance_type
  env = var.env
  ssh_user = var.ssh_user
  ssh_pass = var.ssh_pass
  zone_id = var.zone_id
}