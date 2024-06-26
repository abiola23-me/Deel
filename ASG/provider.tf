provider "aws" {
  region = "us-east-2"
}
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.55.0"
    }
  }
}
