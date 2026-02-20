# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "4.5.0"
#     }
#   }
# }


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


resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block


  tags = {
    Name = "${var.env}-vpc"
  }
}



# resource "aws_subnet" "main" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block = var.subnet_cidr_block
#
#   tags = {
#     Name = "${var.env}-subnet"
#   }
# }



resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}

resource "aws_eip" "igw" {
  count      = length(var.public_subnet)
  domain = "vpc"

}

resource "aws_subnet" "frontend_subnet" {
   count      = length(var.frontend_subnet)
  vpc_id      = aws_vpc.main.id
  cidr_block  = var.frontend_subnet[count.index]
  availability_zone = var.availability_zone[count.index]


  tags = {
    Name = "${var.env}-frontend_subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "frontend" {
  count      = length(var.frontend_subnet)
  vpc_id      = aws_vpc.main.id

  route {
    cidr_block = var.default_cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-frontend-rt-${count.index + 1}"
  }
}

resource "aws_route_table_association" "frontend" {

  count      = length(var.frontend_subnet)
  route_table_id = aws_route_table.frontend[count.index].id
  subnet_id = aws_subnet.frontend_subnet[count.index].id
}


resource "aws_subnet" "backend_subnet" {
  count      = length(var.backend_subnet)
  vpc_id      = aws_vpc.main.id
  cidr_block  = var.backend_subnet[count.index]
  availability_zone = var.availability_zone[count.index]


  tags = {
    Name = "${var.env}-backend_subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "backend" {
  count      = length(var.backend_subnet)
  vpc_id      = aws_vpc.main.id

  route {
    cidr_block = var.default_cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-backend-rt-${count.index + 1}"
  }
}

resource "aws_route_table_association" "backend" {

  count      = length(var.backend_subnet)
  route_table_id = aws_route_table.backend[count.index].id
  subnet_id = aws_subnet.backend_subnet[count.index].id
}

resource "aws_vpc_peering_connection" "main" {
  peer_vpc_id   = var.default_vpc_id
  vpc_id        = aws_vpc.main.id
  auto_accept = true

  tags = {
    Name = "${var.env}-vpc-default-vpc"
  }
}

# resource "aws_subnet" "frontend_subnet" {
#   for_each   = toset(var.frontend_subnet)
#   vpc_id     = aws_vpc.main.id
#   cidr_block = each.value
#
#   tags = {
#     Name = "${var.env}-frontend-subnet"
#   }
# }


resource "aws_subnet" "db_subnet" {
  count      = length(var.db_subnet)
  vpc_id      = aws_vpc.main.id
  cidr_block  = var.db_subnet[count.index]
  availability_zone = var.availability_zone[count.index]


  tags = {
    Name = "${var.env}-db_subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "db" {
  count      = length(var.db_subnet)
  vpc_id      = aws_vpc.main.id

  route {
    cidr_block = var.default_cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-db-rt-${count.index + 1}"
  }
}

resource "aws_route_table_association" "db" {

  count      = length(var.db_subnet)
  route_table_id = aws_route_table.db[count.index].id
  subnet_id = aws_subnet.db_subnet[count.index].id
}

resource "aws_subnet" "public" {
  count      = length(var.public_subnet)
  vpc_id      = aws_vpc.main.id
  cidr_block  = var.public_subnet[count.index]
  availability_zone = var.availability_zone[count.index]


  tags = {
    Name = "${var.env}-public_subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  count      = length(var.public_subnet)
  vpc_id      = aws_vpc.main.id

  route {
    cidr_block = var.default_cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.env}-public-rt-${count.index + 1}"
  }
}

resource "aws_route_table_association" "public" {

  count      = length(var.public_subnet)
  route_table_id = aws_route_table.public[count.index].id
  subnet_id = aws_subnet.public[count.index].id
}




# resource "aws_route" "main" {
#   route_table_id            = aws_vpc.main.default_route_table_id
#   destination_cidr_block    = var.default_cidr_block
#   vpc_peering_connection_id = aws_vpc_peering_connection.main.id
# }





resource "aws_route" "default_vpc" {
  route_table_id            = var.default_route_id
  destination_cidr_block    = var.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}


