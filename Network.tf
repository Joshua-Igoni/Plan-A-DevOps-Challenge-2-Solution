/******************************************************************************
* VPC
*******************************************************************************/

/**
* The VPC is the private cloud that provides the network infrastructure into
* which we can launch our aws resources.  This is effectively the root of our
* private network.
*/
resource "aws_vpc" "eks-vpc" { 

  cidr_block       = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.env-prefix}-vpc"
  }
}

/******************************************************************************
* Public Subnet 
*******************************************************************************/

/**
* A public subnet with in our VPC that we can launch resources into that we
* want to be auto-assigned public ip addresses.  These resources will be
* exposed to the public internet, with public IPs, by default.  They don't need
* to go through, and aren't shielded by, the NAT Gateway.
*/
resource "aws_subnet" "public_subnet" {
  count = length(var.availability_zones)
  vpc_id            = "${aws_vpc.eks-vpc.id}"
  cidr_block = element(var.public_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env-prefix}-public"
  }
}

/**
* A route from the public route table out to the internet through the internet
* gateway.
*/

/**
* Associate the public route table with the public subnets.
*/
# Route the public subnet traffic through the IGW
resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.eks-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main_internet_gateway.id}"
  }

  tags = {
    Name = "${var.env-prefix}-route-table"
  }
}

resource "aws_route_table_association" "internet_access" {
  count = length(var.availability_zones)
  subnet_id      = "${aws_subnet.public_subnet[count.index].id}"
  route_table_id = "${aws_route_table.main.id}"
}
/******************************************************************************
* Private Subnet 
*******************************************************************************/

/** 
* A private subnet for pieces of the infrastructure that we don't want to be
* directly exposed to the public internet.  Infrastructure launched into this
* subnet will not have public IP addresses, and can access the public internet
* only through the route to the NAT Gateway.
*/


resource "aws_subnet" "private_subnet" {
  count = length(var.availability_zones)
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block = element(var.private_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.env-prefix}-private-subnets"
  }
}

/**
* A route from the private route table out to the internet through the NAT  
* Gateway.
*/

resource "aws_route_table" "private_rt" {
    vpc_id             = aws_vpc.eks-vpc.id
    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.main.id
 }
}

/**
* Associate the private route table with the private subnet.
*/
resource "aws_route_table_association" "private-connectivity" {
  count = length(var.availability_zones)
  subnet_id      = "${aws_subnet.private_subnet[count.index].id}"
  route_table_id = "${aws_route_table.private_rt.id}"
}

/**
* Provides a connection between the VPC and the public internet, allowing
* traffic to flow in and out of the VPC and translating IP addresses to public
* addresses.
*/
resource "aws_internet_gateway" "main_internet_gateway" {
  vpc_id        = aws_vpc.eks-vpc.id

  tags = {
    Name        = "${var.env-prefix}-main_internet_gateway"
  }
}

/**
* An elastic IP address to be used by the NAT Gateway defined below.  The NAT
* gateway acts as a gateway between our private subnets and the public
* internet, providing access out to the internet from with in those subnets,
* while denying access in to them from the public internet.  This IP address
* acts as the IP address from which all the outbound traffic from the private
* subnets will originate.
*/
resource "aws_eip" "eip_for_the_nat_gateway" {
  vpc           = true

  tags = { 
    Name        = "${var.env-prefix}-eip_for_the_nat_gateway"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.eip_for_the_nat_gateway.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "NAT Gateway for Custom Kubernetes Cluster"
  }
}

resource "aws_route" "main" {
  route_table_id            = aws_vpc.eks-vpc.default_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}