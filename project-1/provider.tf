terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "terraformudemyadvancedprojectbackendstate"
    key    = "state.tfstate"
    region = "eu-west-2"
    //s3 remote backend support state locking and this is done by dynamodb table 
    //dynamodb_table = "my-dynamodb-table"
  }
}

provider "aws" {
  region = var.AWS_REGION
}