terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    bucket = "lambda-deploy-pipeline-terraform-state"
    key    = "lambda-deploy-pipeline/terraform.tfstate"
    region = "us-east-1"
  }

}

provider "aws" {
  region = var.aws_region
}

# Zip the src/ folder
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../src"
  output_path = "${path.module}/lambda.zip"
}


