resource "aws_vpc" "vpc1" {
  cidr_block = var.cidr_block
  tags = {
    Name = "${var.env}-vpc1"
  }
}
resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.vpc1.id
  count = length(var.cidr_blocks)
  cidr_block = var.cidr_blocks[count.index]
  tags = {
    Name = "${var.env}-public-subnet-${count.index + 1}"
  }
}
resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.vpc1.id
  count = length(var.private_blocks)
  cidr_block = var.private_blocks[count.index]
  tags = {
    Name = "${var.env}-private-subnet-${count.index + 1}"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "${var.env}-igw"
  }
}
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc1.id
  count = length(var.cidr_blocks)
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.env}-public-route-table-${count.index}"
  }
}
resource "aws_route_table_association" "public_route_table_association" {
  count = length(aws_subnet.public_subnets)
  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table[count.index].id
}
resource "aws_eip" "eip" {
  count = 2
  domain = "vpc"
}
resource "aws_nat_gateway" "nat-gateway" {
  count = length(aws_eip.eip)
  allocation_id = aws_eip.eip[count.index].id
  subnet_id = aws_subnet.public_subnets[count.index].id
  tags = {
    Name = "nat-gateway-${count.index}"
  }
  depends_on = [ aws_internet_gateway.igw ]
}
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc1.id
  count = length(var.private_blocks)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gateway[count.index].id
  }
}
resource "aws_route_table_association" "private_route_table_association" {
  count = length(aws_subnet.private_subnets)
  subnet_id = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}
resource "aws_security_group" "allow-all-sg" {
  name = "allow-all-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "alllow-all-sg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow-all-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow-all-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}