resource "aws_vpc" "terra-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "terra-vpc"
  }
}
#subnets --------------------------------
resource "aws_subnet" "terra-public-subnet1" {
  vpc_id                  = aws_vpc.terra-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "terra-public-subnet1"
  }
}

resource "aws_subnet" "terra-public-subnet2" {
  vpc_id                  = aws_vpc.terra-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "terra-public-subnet2"
  }
}

resource "aws_subnet" "terra-private-subnet1" {
  vpc_id            = aws_vpc.terra-vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "terra-private-subnet1"
  }
}

resource "aws_subnet" "terra-private-subnet2" {
  vpc_id            = aws_vpc.terra-vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "terra-private-subnet2"
  }
}
#internet gateway--------------------------------
resource "aws_internet_gateway" "terra-igw" {
  vpc_id = aws_vpc.terra-vpc.id

  tags = {
    Name = "terra-igw"
  }
}
#route tables--------------------------------
resource "aws_route_table" "terra-public-rt" {
  vpc_id = aws_vpc.terra-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra-igw.id
  }

  tags = {
    Name = "terra-public-rt"
  }
}

resource "aws_route_table" "terra-private-rt" {
  vpc_id = aws_vpc.terra-vpc.id

  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_instance.terra-nat-instance.primary_network_interface_id
  }

  tags = {
    Name = "terra-private-rt"
  }
}
#assign subnets to route tables --------------------------------
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.terra-public-subnet1.id
  route_table_id = aws_route_table.terra-public-rt.id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.terra-public-subnet2.id
  route_table_id = aws_route_table.terra-public-rt.id
}
resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.terra-private-subnet1.id
  route_table_id = aws_route_table.terra-private-rt.id
}
resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.terra-private-subnet2.id
  route_table_id = aws_route_table.terra-private-rt.id
}

#security groups--------------------------------
resource "aws_security_group" "terra-mysql-sg" {
  name   = "terra-mysql-sg"
  vpc_id = aws_vpc.terra-vpc.id
  ingress {
    from_port       = var.mysql_port
    to_port         = var.mysql_port
    protocol        = "tcp"
    security_groups = [aws_security_group.terra-back-sg.id]
  }
}

resource "aws_security_group" "terra-memcached-sg" {
  name   = "terra-memcached-sg"
  vpc_id = aws_vpc.terra-vpc.id
  ingress {
    from_port       = var.memcached_port
    to_port         = var.memcached_port
    protocol        = "tcp"
    security_groups = [aws_security_group.terra-back-sg.id]
  }
  egress {
    from_port       = var.memcached_port
    to_port         = var.memcached_port
    protocol        = "tcp"
    security_groups = [aws_security_group.terra-back-sg.id]
  }
}