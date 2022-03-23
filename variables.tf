variable "aws_credentials_file" {
  type = list
}
variable "aws_profile" {
  type = string
}
variable "aws_region" {
  type = string
}
variable "env-prefix" {
  type = string
}
variable "availability_zones" {
  type  = list(string)
  default = ["us-east-2a", "us-east-2b"]
  description = "List of availability zones for the selected region"
}
variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block range for vpc"
}
variable "private_subnet_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
  description = "CIDR block range for the private subnet"
}

variable "public_subnet_cidr_blocks" {
  type = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
  description = "CIDR block range for the public subnet"
}
variable "endpoint_private_access" {
  type = bool
  default = true
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
}
variable "endpoint_public_access" {
  type = bool
  default = true
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled."
}

variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Defaults to AL2_x86_64. Valid values: AL2_x86_64, AL2_x86_64_GPU."
  type = string 
  default = "AL2_x86_64"
}
variable "disk_size" {
  description = "Disk size in GiB for worker nodes. Defaults to 20."
  type = number
  default = 20
}
variable "instance_types" {
  type = list(string)
  default = ["t3a.large"]
  description = "Set of instance types associated with the EKS Node Group."
}
variable "pvt_desired_size" {
  description = "Desired number of worker nodes in private subnet"
  default = 2
  type = number
}

variable "pvt_max_size" {
  description = "Maximum number of worker nodes in private subnet."
  default = 2
  type = number
}

variable "pvt_min_size" {
  description = "Minimum number of worker nodes in private subnet."
  default = 2
  type = number
}



variable cluster_sg_name {
  description = "Name of the EKS cluster Security Group"
  type        = string
}

variable nodes_sg_name {
  description = "Name of the EKS node group Security Group"
  type        = string
}

variable "node_group_name" {
  description = "Name of the Node Group"
  type = string
}
