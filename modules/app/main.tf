terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0, < 7.0.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = ">= 5.0.0, < 6.0.0"
    }
  }
}


resource "aws_security_group" "main" {
  name        = "${var.component}-${var.env}-sg"
  description = "${var.component}-${var.env}-sg"
  vpc_id      = var.vpc_id

  ingress {
    #description = "SSH"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.component}-${var.env}-sg"
  }
}




resource "aws_instance" "instance" {
  ami = data.aws_ami.ami.image_id
  instance_type = var.instance_type

  subnet_id = var.subnets[0]

# vpc_security_group_ids = [data.aws_security_group.selected.id]

  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {

    Name= var.component
    monitor = "yes"
    env = var.env

  }
}


resource "null_resource" "ansible" {


  connection {
    type        = "ssh"
    user        = jsondecode(data.vault_generic_secret.ssh.data_json).ansible_username
    password    = jsondecode(data.vault_generic_secret.ssh.data_json).ansible_password
    #host        = aws_instance.instance.public_ip
    host        = aws_instance.instance.private_ip

  }

  provisioner "remote-exec" {



    inline = [

      "rm -f ~/*.json",
      "sudo pip3 install ansible hvac",

      "ansible-pull  -i localhost, -U https://github.com/awsdevops-sbs/ansible.git  get-secrets.yml -e role_name=${var.component}  -e env=${var.env} -e vault_token=${var.vault_token} ",
      "ansible-pull  -i localhost, -U https://github.com/awsdevops-sbs/ansible.git  expense.yml -e role_name=${var.component}  -e env=${var.env} -e vault_token=${var.vault_token} -e  @~/secret.json -e @~/app.json"
      #"ansible-pull  -i localhost, -U https://github.com/awsdevops-sbs/ansible.git  expense.yml -e role_name=${var.component} -e NEW_RELIC_KEY=${var.new_relic_key} -e env=${var.env} -e vault_token=${var.vault_token} -e  @~/secret.json -e @~/app.json"

    ]
  }

  provisioner "remote-exec" {
    inline = [
      "rm -f ~/secrets.json ~/app.json"
    ]
  }


}

resource "aws_lb" "main" {
  count = var.lb_needed ? false : true
  name               = "${var.component}-${var.env}-alb"
  internal           = var.lb_type == "public" ? 1 : 0
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets            =  var.subnets


  tags = {
    Environment ="${var.component}-${var.env}-lb"
  }
}


resource "aws_route53_record" "record" {
  name    = "${var.component}-${var.env}"
  type    = "A"
  zone_id = "${var.zone_id}"
  records = [aws_instance.instance.private_ip]
  ttl     = "300"
}

