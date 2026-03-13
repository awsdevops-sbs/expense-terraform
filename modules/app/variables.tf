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

variable "lb_type" {
  default = null

}
variable "lb_needed" {
  default = null
}

variable "lb_subnets" {
  default = null
}

variable "app_port"  {
  default = null
}



variable "server_app_port_sg_cidr" {}

variable "bastion_nodes" {}

variable "prometheus_nodes" {}

variable "lb_app_port_sg_cidr" {

  default = []
}

variable "acm_certificate_arn" {}

variable "lb_ports" {

  default = {}
}

variable "kms_key_id" {}
