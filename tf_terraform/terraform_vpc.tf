resource "aws_vpc" "ddemo-vpc" {  
cidr_block = var.vpc-cidr

  tags = {
    Name = "ddemo-vpc"
  }
}
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.ddemo-vpc.id
  cidr_block              = var.subnet1-cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet1_pub"
  }
}
resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.ddemo-vpc.id
  cidr_block              = var.subnet2-cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet1_pub2"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.ddemo-vpc.id

  dynamic "ingress" {
    for_each = [22, 80, 443, 3306]
    iterator = port
    content {
      description      = "TLS from VPC"
      from_port        = port.value
      to_port          = port.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"] 
   }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_internet_gateway" "IGforteraform" {
  vpc_id = aws_vpc.ddemo-vpc.id
  tags = {
    Name = "IGfortf testing"
  }
}


resource "aws_route_table" "routetable_ddemo" {
  vpc_id = aws_vpc.ddemo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGforteraform.id
  }

  tags = {
    Name = "RT_ddemoTFtest"
  }
}


resource "aws_route_table_association" "RT-asst_ddemo" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.routetable_ddemo.id
}

