provider "aws" {
  shared_credentials_files = var.aws_credentials_file
  profile                  = var.aws_profile
  region                   = var.aws_region
}