resource "aws_db_instance" "default" {
  identifier           = "${var.component}-${var.env}"
  allocated_storage    = var.allocated_storage
  db_name              = "mydb"
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = jsondecode(data.vault_generic_secret.rds.data_json).rds_username
  password             = jsondecode(data.vault_generic_secret.rds.data_json).rds_password
  parameter_group_name = aws_db_parameter_group.main.name
  skip_final_snapshot  = var.skip_final_snapshot
  storage_type         = var.storage_type
  publicly_accessible   = no
  db_subnet_group_name = aws_db_subnet_group.default
  vpc_security_group_ids = [aws_security_group.main.id]
  multi_az               = false
  }

resource "aws_db_parameter_group" "main" {
  name   = "${var.component}-${var.env}-pg"
  family = var.family

}

  resource "aws_db_subnet_group" "default" {
    name       = "${var.component}-${var.env}-subnet-group"
    subnet_ids = var.subnets

    tags = {
      Name = "${var.component}-${var.env}-subnet-group"
    }
  }

resource "aws_security_group" "main" {

  name        = "${var.component}-${var.env}-sg"
  description = "${var.component}-${var.env}-sg"
  vpc_id      = var.vpc_id


  ingress {
    #description = "SSH"
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = var.serserver_app_port_sg_cidr
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


