
module "fn-rotate-app-key" {
  source             = "./_modules/aws-lambda"
  function_name      = "fn-rotate-app-key"
  function_handler   = "handler.function.handle"
  runtime            = "python3.9"
  execution_role_arn = "arn:aws:iam::${local.account_id}:role/iamsr/lambda-function-role"
  function_source    = "../app/functions/fn-rotate-app-key/bin/function.zip"
}

resource "aws_lambda_permission" "this" {
  statement_id  = "SecretManagerInvokeFunciton"
  action        = "lambda:InvokeFunction"
  function_name = module.fn-rotate-app-key.function_name
  principal     = "secretsmanager.amazonaws.com"
}


module "fn-rotate-expire-app-key" {
  source             = "./_modules/aws-lambda"
  function_name      = "fn-rotate-expire-app-key"
  function_handler   = "handler.function.handle"
  runtime            = "python3.9"
  execution_role_arn = "arn:aws:iam::${local.account_id}:role/iamsr/lambda-function-role"
  function_source    = "../app/functions/fn-rotate-expire-app-key/bin/function.zip"
}

resource "aws_lambda_event_source_mapping" "this" {
  event_source_arn = aws_dynamodb_table.this.stream_arn
  function_name    = module.fn-rotate-expire-app-key.function_name
  filter_criteria {
    filter {
      pattern = jsonencode({
        "userIdentity" : {
          "type" : ["Service"]
          "principalId" : ["dynamodb.amazonaws.com"]
        }
      })
    }
  }
  starting_position              = "TRIM_HORIZON"
  maximum_retry_attempts         = 1
  bisect_batch_on_function_error = true
  enabled                        = true
}
