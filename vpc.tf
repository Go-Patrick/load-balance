// Set up VPC
resource "aws_vpc" "load" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "demo"
  }
}

# Set up Subnets
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.load.id
  cidr_block = "10.0.1.0/24"

  map_public_ip_on_launch = true

  tags = {
    Name = "load-public-1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.load.id
  cidr_block = "10.0.2.0/24"

  map_public_ip_on_launch = true

  tags = {
    Name = "load-public-2"
  }
}

resource "aws_subnet" "lb1" {
  vpc_id     = aws_vpc.load.id
  cidr_block = "10.0.3.0/24"

  map_public_ip_on_launch = true

  tags = {
    Name = "load-lb-1"
  }
}

resource "aws_subnet" "lb2" {
  vpc_id     = aws_vpc.load.id
  cidr_block = "10.0.4.0/24"

  map_public_ip_on_launch = true

  tags = {
    Name = "load-lb-2"
  }
}

// Set up Gateway and Route table
resource "aws_internet_gateway" "load_igw" {
  vpc_id = aws_vpc.load.id
}

resource "aws_route_table" "load_rt" {
  vpc_id = aws_vpc.load.id

  tags = {
    Name = "load=rt"
  }
}

resource "aws_route" "load_route" {
  route_table_id         = aws_route_table.load_rt.id
  gateway_id             = aws_internet_gateway.load_igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "ass1" {
  route_table_id = aws_route_table.load_rt.id
  subnet_id      = aws_subnet.lb1.id
}

resource "aws_route_table_association" "ass2" {
  route_table_id = aws_route_table.load_rt.id
  subnet_id      = aws_subnet.lb2.id
}

resource "aws_route_table_association" "ass3" {
  route_table_id = aws_route_table.load_rt.id
  subnet_id      = aws_subnet.public1.id
}

resource "aws_route_table_association" "ass4" {
  route_table_id = aws_route_table.load_rt.id
  subnet_id      = aws_subnet.public2.id
}

// Set up security group
resource "aws_security_group" "load_sg" {
  name        = "load-sc"
  description = "Allow HTTP, HTTPS and SSH"
  vpc_id      = aws_vpc.load.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "load-sg"
  }
}