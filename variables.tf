variable "env" {}
variable "instance_type" {}
# variable "ssh_user" {}
# variable "ssh_pass" {}
variable "zone_id" {}
variable "vault_token" {}
#variable "new_relic_key" {}

variable "vpc_cidr_block" {}
#variable "subnet_cidr_block" {}

variable "default_vpc_id" {}
variable "default_cidr_block" {}

variable "default_route_id" {}
variable "public_subnet" {}
variable "frontend_subnet" {}
variable "backend_subnet" {}
variable "db_subnet" {}
variable "availability_zone" {}

variable "lb_type" {
  default = null
}

variable "lb_needed" {
  default = null
}
variable "lb_subnets" {
  default = null
}

variable app_port  {
  default = null
}

variable "server_app_port_sg_cidr" {}

variable "bastion_nodes" {}

variable "prometheus_nodes" {}

variable "lb_app_port_sg_cidr" {}