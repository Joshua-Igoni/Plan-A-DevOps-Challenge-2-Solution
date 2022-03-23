# Plan-A-DevOps-Challenge-2-Solution

# Usage

The purpose of this repo is to deploy an Eks cluster to a vpc, with nodes runing in the private subnets.
To successfull deploy this infrastructure you will need the following.
- An aws account with free tier. You can follow the instructions to create an aws account [here](https://portal.aws.amazon.com/billing/signup#/start/email)
- A user in aws with full programatic access. when the user is created, take note of the secret and access keys, they will be used later to configure the aws cli. A proper documentation of how a user is created is stated [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html).
- AWS cli installed. You can follow the instructions on how to install and set it up [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html)
- terraform installed. You can find the step by step guide [here](https://learn.hashicorp.com/tutorials/terraform/install-cli).
- terraform.tfvars file to hold some values for your variables.

### STEP 1

Clone the github repository

```bash
  git clone https://github.com/Joshua-Igoni/Plan-A-DevOps-Challenge-2-Solution
```
### STEP 2
Go through the terraform files. In the "variables.tf" file, all variables that
do not have a default value needs to be declared in the "terraform.tfvars" file which you will create.

create a terraform.tfvars file and input the following as it applies to you;

```bash
   aws_credentials_file = ["~/.aws/credentials"] ##path to your aws credentails file
   aws_profile = "Bolten"                        ###the name of the profile (found at ~/.aws/config)
   aws_region = "us-east-2"                      ###the region you wish to deploy your resources
   env-prefix = "EKS"                            ###to customize names given to objects in your infrastructure
   cluster_sg_name = "EKS-Plan-A-security-group" ###A customized name for your cluster sg
   nodes_sg_name = "EKS-Plan-A-sg-name"          ###A customized name for your node sg
   node_group_name = "EKS-Plan-A-node-group"     ###A customized name for your node group
```
### STEP 3

After variables have been declared
Its time to deploy your infrastructure
Run the following commands

```bash
  terraform init
```
```bash
  Terraform plan
```
```bash
  Terraform apply --auto-approve
```

### STEP 4

After infrastructure has been deployed, run the following command to destroy infrastructure, so as to aviod being charged.

```bash
  terraform destroy --auto-approve
```