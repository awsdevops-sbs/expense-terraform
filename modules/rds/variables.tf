variable "component" {}
variable "env" {}
variable "family" {}
variable "subnets" {}
variable "storage_type" {

  default = null
}
variable "skip_final_snapshot" {}
variable "instance_class" {}
variable "engine_version" {}
variable "engine" {}
variable "allocated_storage" {
  default = null
}

variable "vpc_id" {}

variable "serserver_app_port_sg_cidr" {}