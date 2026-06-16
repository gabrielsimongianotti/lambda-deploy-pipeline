resource "aws_s3_bucket" "terraform_state" {
  bucket = "lambda-deploy-pipeline-terraform-state"

  tags = {
    Name        = "terraform-state"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
