# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.10.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "main"
    Owner = "matanel"
  }
}

# Create subnets
resource "aws_subnet" "public_sub" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.0.0/24"
  map_public_ip_on_launch = "true" 
  availability_zone       = "${var.aws_region}a"
  tags = {
    Name = "public_sub",
    Owner = "matanel"
  }
}

resource "aws_subnet" "private_sub" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.1.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.aws_region}a"
  tags = {
    Name = "private_sub",
    Owner = "matanel"
  }
}

# Create IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "igw",
    Owner = "matanel"
  }
}

# Create NAT
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_sub.id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "nat_gw",
    Owner = "matanel"
  }
}

# Create EIP
resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name = "nat_eip",
    Owner = "matanel"
  }
}

# Create 2 Route Tables
resource "aws_route_table" "route_public" {
  vpc_id = aws_vpc.main.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }
  tags = {
    Name = "route_public",
    Owner = "matanel"
  }
}

resource "aws_route_table" "route_private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id 
  }
  tags = {
    Name = "route_private",
    Owner = "matanel"
  }
}

# Create Route associations
resource "aws_route_table_association" "assoc_public" {
  subnet_id      = aws_subnet.public_sub.id
  route_table_id = aws_route_table.route_public.id
}
resource "aws_route_table_association" "assoc_private" {
  subnet_id      = aws_subnet.private_sub.id
  route_table_id = aws_route_table.route_private.id
}