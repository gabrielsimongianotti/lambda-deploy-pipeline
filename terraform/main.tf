# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#     archive = {
#       source  = "hashicorp/archive"
#       version = "~> 2.0"
#     }
#   }
# }

# provider "aws" {
#   region = var.aws_region
# }

# # Zip the src/ folder
# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   source_dir  = "${path.module}/../src"
#   output_path = "${path.module}/lambda.zip"
# }

# # IAM role
# resource "aws_iam_role" "lambda_exec" {
#   name = "${var.function_name}-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect    = "Allow"
#       Action    = "sts:AssumeRole"
#       Principal = { Service = "lambda.amazonaws.com" }
#     }]
#   })
# }

# # Attach basic logging policy
# resource "aws_iam_role_policy_attachment" "lambda_basic" {
#   role       = aws_iam_role.lambda_exec.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }

# # Lambda function
# resource "aws_lambda_function" "main" {
#   function_name    = var.function_name
#   filename         = data.archive_file.lambda_zip.output_path
#   source_code_hash = data.archive_file.lambda_zip.output_base64sha256

#   role    = aws_iam_role.lambda_exec.arn
#   handler = "index.handler"
#   runtime = "nodejs20.x"

#   environment {
#     variables = {
#       ENV = var.environment
#     }
#   }

#   depends_on = [aws_iam_role_policy_attachment.lambda_basic]
# }

# # CloudWatch logs
# resource "aws_cloudwatch_log_group" "lambda_logs" {
#   name              = "/aws/lambda/${var.function_name}"
#   retention_in_days = 14
# }


resource "aws_s3_bucket" "bucket-images" {
  bucket        = var.bucket_name
  force_destroy = true
  tags = {
    Name = "files"
  }
}


resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.bucket-images.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
