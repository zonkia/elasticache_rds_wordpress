terraform {
  required_version = "1.5.2"
  required_providers { 
    aws = {
      source  = "hashicorp/aws"
      version = "4.56.0"
    }
  }
}

provider "aws" {
  region = var.region
}