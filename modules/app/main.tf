
resource "aws_instance" "instance" {
  ami = data.aws_ami.ami.image_id
  instance_type = var.instance_type
vpc_security_group_ids = [data.aws_security_group.selected.id]

  tags = {

    Name= var.component
    monitor = "yes"
    env = var.env

  }
}


resource "null_resource" "ansible" {

  provisioner "remote-exec" {

    connection {
      type        = "ssh"
      user        = jsondecode(data.vault_generic_secret.ssh.data_json).ansible_username
      password    = jsondecode(data.vault_generic_secret.ssh.data_json).ansible_password
      host        = aws_instance.instance.public_ip

    }

    inline = [
      "sudo pip3.11 install ansible hvac",
      #"sudo /usr/bin/python3.13 -m pip install --upgrade pip",
      #"sudo /usr/bin/python3.13 -m pip install ansible hvac",
      "ansible-pull  -i localhost, -U https://github.com/awsdevops-sbs/ansible.git  get-secrets.yml -e role_name=${var.component}  -e env=${var.env} -e vault_token=${vault_token} ",
      "ansible-pull  -i localhost, -U https://github.com/awsdevops-sbs/ansible.git  expense.yml -e role_name=${var.component}  -e env=${var.env} -e vault_token=${vault_token} -e '@secret.json'"

    ]
  }

}


resource "aws_route53_record" "record" {
  name    = "${var.component}-${var.env}"
  type    = "A"
  zone_id = "${var.zone_id}"
  records = [aws_instance.instance.private_ip]
  ttl     = "300"
}

