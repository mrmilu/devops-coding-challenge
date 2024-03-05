# This example illustrates Terraform configuration for managing infra on AWS.
# is required ensure that the specified S3 bucket exists or the init project will fail
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2.0"

  backend "s3" {
    bucket = "NAME_BUCKET.terraform-state"
    region = "eu-west-1"
    key    = "terraform.state"
    shared_credentials_files= ["/Users/USERNAME/.aws/credentials"]
    profile = "AWS_ACCOUNT_NAME-terraform"
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "xxxx-terraform"
}

# Initialize your Terraform project by running:
# terraform init

# Alternative to this method you can use the CLI like the following example:

# terraform init -backend-config=bucket=NAME_BUCKET.terraform-state -backend-config=key=terraform.tfstate \
# -backend-config=region=eu-west-1 -backend-config=shared_credentials_file="~/.aws/credentials" \
# -backend-config=profile=AWS_ACCOUNT_NAME-terraform
