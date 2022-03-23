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