resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 7
}

resource "aws_lambda_function" "this" {
  filename         = var.function_source
  function_name    = var.function_name
  handler          = var.function_handler
  role             = var.execution_role_arn
  source_code_hash = filebase64sha256(var.function_source)
  runtime          = var.runtime
  memory_size      = 1024
  timeout          = 30
}
