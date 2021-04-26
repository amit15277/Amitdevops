######## VPC_networking/main.tf

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.name}-VPC"
    Environment = var.ENV
    ManagedBy   = "Terraform"


  }
}


// PUBLIC Subnet,Routes and Association
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_cidrs) > 1 ? length(var.public_cidrs) : 0
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = element(var.az, count.index)

  tags = {
    Name        = "${var.name}-PUBLIC${count.index + 1}"
    Environment = var.ENV
    ManagedBy   = "Terraform"


  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  count  = length(var.public_cidrs) > 1 ? 1 : 0

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw[0].id
  }
  tags = {
    Name        = "${var.name}-PUBLIC"
    Environment = var.ENV
    ManagedBy   = "Terraform"


  }
}

resource "aws_route_table_association" "public_subnet_assoc" {
  count          = length(var.public_cidrs) > 1 ? length(var.public_cidrs) : 0
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt[0].id
}

//// PRIVATE Subnet,Routes and Association
resource "aws_subnet" "private_subnet" {
  count  = length(var.private_cidrs) > 1 ? length(var.az) * var.private_subnets_per_az : 0
  vpc_id = aws_vpc.vpc.id

  cidr_block        = var.private_cidrs[count.index]
  availability_zone = element(var.az, count.index)

  tags = {
    Name        = "${var.name}-PRIVATE${count.index + 1}"
    Environment = var.ENV
    ManagedBy   = "Terraform"


  }
}

resource "aws_default_route_table" "private_rt" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw[0].id
  }
  tags = {
    Name        = "${var.name}-PRIVATE"
    Environment = var.ENV
    ManagedBy   = "Terraform"


  }
}

resource "aws_route_table_association" "private_subnet_assoc" {
  count          = length(var.private_cidrs) > 1 ? length(var.private_cidrs) : 0
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_default_route_table.private_rt.id
}

// Internet Gateway
resource "aws_internet_gateway" "internet_gw" {
  count  = length(var.public_cidrs) > 1 ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.name}-IGW"
    Environment = var.ENV
    ManagedBy   = "Terraform"


  }
}

//Create EIP for NAt
resource "aws_eip" "nat_eip" {
  vpc   = true
  count = length(var.public_cidrs) > 1 ? var.nat_gw_count : 0
  tags = {
    Name        = "${var.name}-NAT-EIP"
    Environment = var.ENV
    ManagedBy   = "Terraform"


  }
}

resource "aws_nat_gateway" "nat_gw" {
  count         = length(var.public_cidrs) > 1 ? var.nat_gw_count : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)

  tags = {
    Name        = "${var.name}-NAT-GW"
    Environment = var.ENV
    ManagedBy   = "Terraform"


  }
}
