#------------------------------custom network------------------------------
# create vpc
resource "aws_vpc" "cust" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name ="dev"
  }
}
# create internet gateay and attach to vpc
resource "aws_internet_gateway" "cust" {
    vpc_id = aws_vpc.cust.id

    tags = {
      Name = "cust-ig"
    }
  
}
# create subnet
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.cust.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-south-1a"

    tags = {
      Name="cudt-subnet"
    }
  
}
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.cust.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1b"

    tags = {
      Name="cudt-subnet"
    }
  
}

# create route table
resource "aws_route_table" "rou" {
 vpc_id = aws_vpc.cust.id

  route  {
      gateway_id = aws_internet_gateway.cust.id
      cidr_block = "0.0.0.0/0"
 }

 
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.cust.id
 
  route {
   cidr_block = "0.0.0.0/0"
   nat_gateway_id = aws_nat_gateway.nat.id
 }
}





#allocate en elastic ip
resource "aws_eip" "nat_eip" {
  
   domain = "vpc"

}

#create nat gatway in public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.private.id
  
}



# subnet assocation and subnets into rt 
resource "aws_route_table_association" "cust" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.rou.id
  
}

resource "aws_route_table_association" "private_subnet_assocation" {
    subnet_id = aws_subnet.private.id
    route_table_id = aws_route_table.private.id
  
}

# create security groups 
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  vpc_id      = aws_vpc.cust.id
  tags = {
    Name = "dev_sg"
  }
 ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

}

# launch instance

