
resource "aws_lambda_function" "main" {
  function_name    = var.function_name
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  role    = aws_iam_role.lambda_exec.arn
  handler = "index.handler"
  runtime = "nodejs20.x"

  environment {
    variables = {
      ENV = var.environment
    }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_basic]
}
