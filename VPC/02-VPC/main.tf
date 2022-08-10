provider "aws" {
  region     = "${var.region}"
  profile = "default" # Credentials are set in Bash Profile
}

# Use S3 backend
terraform {
  backend "s3" {
    # Replace this with your bucket data
    bucket         = "terraform-state-hyorch-vpc"   
    key            = "vpc_ireland_s3backend/terraform.tfstate"
    # Make dynamic folder using
    # terraform init -var-file ireland_vars.tfvars -backend-config="key=folder_name/terraform.tfstate"
    region         = "eu-west-1"
  }
}

# VPC resources: This will create 1 VPC with 6 Subnets, 1 Internet Gateway, 6 Route Tables. 
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.vpc_name}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {  
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc_name}_IG"
  }
}

# NAT for private networks to connect Internet
resource "aws_eip" "ip_nat" {
  count = length(var.public_subnet_cidr_blocks)
  vpc = true
  tags = {
    Name = "${var.vpc_name}-Public_IP_${var.vpc_name}"  
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  depends_on = [aws_internet_gateway.internet_gateway]

  count = length(var.public_subnet_cidr_blocks)

  allocation_id = aws_eip.ip_nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = {
    Name = "${var.vpc_name}-NAT_Gateway_${var.public_subnet_cidr_blocks[count.index]}"  
  }
}

# Network Definition
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.vpc_name}-PrivateNet_${var.private_subnet_cidr_blocks[count.index]}"  
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-PublicNet_${var.public_subnet_cidr_blocks[count.index]}"  
  }
}

# Private Routing
resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc_name}RT_Private_${var.private_subnet_cidr_blocks[count.index]}"  
  }
}

resource "aws_route" "private" {
  count = length(var.private_subnet_cidr_blocks)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[count.index].id 
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr_blocks)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# Public Routing
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc_name}RT_Public"  
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id  
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr_blocks)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
