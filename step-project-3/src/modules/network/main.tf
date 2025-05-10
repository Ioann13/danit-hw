resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name  = "ioann-vpc"
    Owner = var.owner
  }
}

resource "aws_subnet" "main-public" {
  count      = length(var.public_subnet_cidr)
  cidr_block = element(var.public_subnet_cidr, count.index)

  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags = {
    Name  = "ioann Public subnet ${count.index + 1}"
    Owner = var.owner
  }
}

resource "aws_subnet" "main-private" {
  count      = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.private_subnet_cidr, count.index)

  tags = {
    Name  = "ioann Private subnet ${count.index}"
    Owner = var.owner
  }
}

resource "aws_eip" "main-nat-eip" {
  count  = length(var.private_subnet_cidr)
  domain = "vpc"

  tags = {
    Owner = var.owner
  }
}

resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Owner = var.owner
  }
}

resource "aws_nat_gateway" "main-ngw" {
  count         = length(var.private_subnet_cidr)
  allocation_id = aws_eip.main-nat-eip[count.index].id
  subnet_id     = aws_subnet.main-public[count.index].id

  tags = {
    Owner = var.owner
  }

  depends_on = [aws_internet_gateway.main-igw]
}

resource "aws_route_table" "main-rt-public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }

  tags = {
    Owner = var.owner
  }
}

resource "aws_route_table_association" "main-rt-association-public" {
  count = length(var.public_subnet_cidr)
  # subnet_id      = element(var.public_subnet_cidr, count.index).id
  subnet_id      = aws_subnet.main-public[count.index].id
  route_table_id = aws_route_table.main-rt-public.id
}

resource "aws_route_table" "main-rt-private" {
  count  = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main-ngw[count.index].id
  }

  tags = {
    Owner = var.owner
  }
}

resource "aws_route_table_association" "main-rt-association-private" {
  count = length(var.private_subnet_cidr)
  # subnet_id      = element(var.private_subnet_cidr, count.index).id
  subnet_id      = aws_subnet.main-private[count.index].id
  route_table_id = aws_route_table.main-rt-private[count.index].id
}
