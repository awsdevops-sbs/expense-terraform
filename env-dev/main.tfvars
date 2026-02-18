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
backend_subnet    =["10.10.0.64/27", "10.10.0.96/27"]
db_subnet         =["10.10.0.128/27", "10.10.0.160/27"]
availability_zone =["us-east-1a","us-east-1b"]



