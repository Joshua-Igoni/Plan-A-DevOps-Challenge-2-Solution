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

  tags = { 
    Name                = "EKS-VPC"
  }
}