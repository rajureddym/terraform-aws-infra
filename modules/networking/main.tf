provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    LaunchedBy = "Terraform"
    Name = "MyVPC"
  }
}

resource "aws_subnet" "my_public_subnet_01" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.public_subnet_cidr_block_01
  availability_zone = var.availability_zone_names[0]

  tags = {
    LaunchedBy = "Terraform"
    Name = "MyVPCPublicSubnet01"
  }
}
resource "aws_subnet" "my_public_subnet_02" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.public_subnet_cidr_block_02
  availability_zone = var.availability_zone_names[1]

  tags = {
    LaunchedBy = "Terraform"
    Name = "MyVPCPublicSubnet02"
  }
}
resource "aws_subnet" "my_private_subnet_01" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_cidr_block_01
  availability_zone = var.availability_zone_names[0]

  tags = {
    LaunchedBy = "Terraform"
    Name = "MyVPCPrivateSubnet01"
  }
}
resource "aws_subnet" "my_private_subnet_02" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_cidr_block_02
  availability_zone = var.availability_zone_names[1]

  tags = {
    LaunchedBy = "Terraform"
    Name = "MyVPCPrivateSubnet02"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    LaunchedBy = "Terraform"
  }
}

resource "aws_eip" "my_eip_1a_nat" {
  vpc        = true
  depends_on = [aws_internet_gateway.my_igw]
  tags = {
    LaunchedBy = "Terraform"
  }
}

resource "aws_eip" "my_eip_1b_nat" {
  vpc        = true
  depends_on = [aws_internet_gateway.my_igw]
  tags = {
    LaunchedBy = "Terraform"
  }
}

resource "aws_nat_gateway" "my_nat_1a" {

  subnet_id     = aws_subnet.my_public_subnet_01.id
  allocation_id = aws_eip.my_eip_1a_nat.id
  depends_on    = [aws_internet_gateway.my_igw]
  tags = {
    LaunchedBy = "Terraform"
  }

}

resource "aws_nat_gateway" "my_nat_1b" {

  subnet_id     = aws_subnet.my_public_subnet_02.id
  allocation_id = aws_eip.my_eip_1b_nat.id
  depends_on    = [aws_internet_gateway.my_igw]
  tags = {
    LaunchedBy = "Terraform"
  }

}

resource "aws_route_table" "my_rt_public" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "MyPublicRouteTable"
  }
}

resource "aws_route_table" "my_rt_private_1a" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_nat_1a.id
  }

  tags = {
    Name = "MyPrivateRouteTable1a"
  }
}

resource "aws_route_table" "my_rt_private_1b" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_nat_1b.id
  }
  tags = {
    Name = "MyPrivateRouteTable1b"
  }
}

resource "aws_route_table_association" "my_rt_public_a" {
  subnet_id      = aws_subnet.my_public_subnet_01.id
  route_table_id = aws_route_table.my_rt_public.id
}

resource "aws_route_table_association" "my_rt_public_b" {
  subnet_id      = aws_subnet.my_public_subnet_02.id
  route_table_id = aws_route_table.my_rt_public.id
}

resource "aws_route_table_association" "my_rt_private_a_1a" {
  subnet_id      = aws_subnet.my_private_subnet_01.id
  route_table_id = aws_route_table.my_rt_private_1a.id
}

resource "aws_route_table_association" "my_rt_private_a_1b" {
  subnet_id      = aws_subnet.my_private_subnet_02.id
  route_table_id = aws_route_table.my_rt_private_1b.id
}
