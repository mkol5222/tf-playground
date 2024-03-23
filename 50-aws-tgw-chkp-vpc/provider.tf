
terraform {
  required_providers {
    aws = {
      version = ">= 3.28.0"
      source  = "hashicorp/aws"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=2.3.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

