/******************************************************************************
* VPC
*******************************************************************************/

/**
* The VPC is the private cloud that provides the network infrastructure into
* which we can launch our aws resources.  This is effectively the root of our
* private network.
*/
resource "aws_vpc" "eks-vpc" {
  cidr_block            = "172.0.0.0/16"
  enable_dns_hostnames  = true
  enable_dns_support    = true

  tags = { 
    Name                = "EKS-VPC"
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
resource "aws_subnet" "public_subnets" {
    vpc_id                  = aws_vpc.eks-vpc.id
    cidr_block              = cidrsubnet(aws_vpc.eks-vpc.cidr_block, 8, 2 + count.index)
    availability_zone       = element(var.availability_zones, count.index)
    map_public_ip_on_launch = true
    count                   = var.public_subnets_count
    tags = {
        Name                = "${env-prefix}-${count.index * 2 +1}.0_${element(var.availability_zones, count.index)}"

 }
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


resource "aws_subnet" "private_subnets" {
    vpc_id                  = aws_vpc.main_vpc.id
    cidr_block              = cidrsubnet(aws_vpc.main_vpc.cidr_block, 8, count.index)
    availability_zone       = element(var.availability_zones, count.index)
    map_public_ip_on_launch = false
    count                   = var.private_subnets_count

    tags = {
        Name                = "${env-prefix}-${count.index *2}.0_${element(var.availability_zones, count.index)}"
 }
}