env = "dev"
instance_type = "t3.small"
# ssh_user = "ec2-user"
# ssh_pass = "DevOps321"
zone_id = "Z08526923KQ6ZDBXQJFC1"
vpc_cidr_block       = "10.10.0.0/24"
#subnet_cidr_block     = "10.10.0.0/24"
default_vpc_id = "vpc-0d2850636350f0540"
default_cidr_block = "172.31.0.0/16"

default_route_id = "rtb-0fedb05ba9d826ae9"

frontend_subnet   =["10.10.0.0/27","10.10.0.32/27"]
backend_subnet    =["10.10.0.64/27","10.10.0.96/27"]
db_subnet         =["10.10.0.128/27","10.10.0.160/27"]
public_subnet      =["10.10.0.192/27","10.10.0.224/27"]

availability_zone =["us-east-1a","us-east-1b"]

bastion_nodes = ["172.31.79.79/32"]
prometheus_nodes = ["172.31.16.63/32"]

acm_certificate_arn = "arn:aws:acm:us-east-1:001068834011:certificate/8aaa81fe-b9dc-4efe-a76e-2bacefc4a5f3"
kms_key_id          = "arn:aws:kms:us-east-1:001068834011:key/3cfc6411-5d6b-443c-9eed-e8df63be6485"


max_capacity = "5"
min_capacity = "1"
desired_capacity = "1"

