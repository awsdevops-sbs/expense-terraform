variable "env" {}
variable "instance_type" {}
variable "component" {}
# variable "ssh_user" {}
# variable "ssh_pass" {}
variable "zone_id" {}
variable "vault_token" {}
#variable "new_relic_key" {}
variable "vpc_id" {}
variable "subnets" {}
variable "app_port"  {
  default = null
}
variable "server_app_port_sg_cidr" {}
variable "bastion_nodes" {}
variable "prometheus_nodes" {}

variable "desired_capacity" {}
variable "min_capacity" {}
variable "max_capacity" {}




