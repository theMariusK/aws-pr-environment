terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = "marius-pr-env-state"
    key = "terraform.tfstate"
    region = "eu-north-1"
    encrypt = true
  }
}

provider "aws" {
  region = "eu-north-1"
}

data "aws_ssm_parameter" "db_password" {
  name = "/database/password"
  with_decryption = true
}
