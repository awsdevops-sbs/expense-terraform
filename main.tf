module "frontend" {
  source = "./modules/app"
  component = "frontend"
  instance_type = var.instance_type
  env = var.env
  ssh_user = var.ssh_user
  ssh_pass = var.ssh_pass
  zone_id = var.zone_id
}

# module "backend" {
#   source = "./modules/app"
#   name = "frontend"
#   instance_type = "t3.small"
# }
#
# module "mysql" {
#   source = "./modules/app"
#   name = "frontend"
#   instance_type = "t3.small"
# }