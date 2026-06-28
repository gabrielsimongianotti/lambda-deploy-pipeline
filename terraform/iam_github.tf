resource "aws_iam_user_policy" "github_s3_backend_access" {
  name = "s3-backend-access"
  user = "github-lambda-deploy-pipeline" # ajuste pro nome real do seu usuário

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetBucketPolicy",
          "s3:PutBucketPolicy",
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::lambda-deploy-pipeline-terraform-state",
          "arn:aws:s3:::lambda-deploy-pipeline-terraform-state/*"
        ]
      }
    ]
  })
}
