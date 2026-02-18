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

resource "aws_subnet" "frontend_subnet" {
   count      = length(var.frontend_subnet)
  vpc_id      = aws_vpc.main.id
  cidr_block  = var.frontend_subnet[count.index]
  availability_zone = var.availability_zone[count.index]


  tags = {
    Name = "${var.env}-frontend_subnet-${count.index + 1}"
  }
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

resource "aws_route" "main" {
  route_table_id            = aws_vpc.main.default_route_table_id
  destination_cidr_block    = var.default_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

resource "aws_route" "default_vpc" {
  route_table_id            = var.default_route_id
  destination_cidr_block    = var.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}


