
resource "aws_secretsmanager_secret" "this" {
  name = "${local.prefix}-example-${random_string.this.result}"
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id
  secret_string = jsonencode({
    "id" : "a2555e95-9db8-48be-94f8-2a28577c0b4a",
    "appKey" : "app-myaccount-ORYNWX",
    "appToken" : "WNVUJKYFKJFLTPXHQGAZDHPBHSDQVJJWSFZUBOGCKPEXAIFHTPANKJTOXU",
    "label" : "my new appkey",
    "createdIn" : "2018-07-04T14:09:08.2718405Z",
    "isActive" : true
  })
}

resource "aws_secretsmanager_secret_rotation" "this" {
  secret_id           = aws_secretsmanager_secret.this.id
  rotation_lambda_arn = module.fn-rotate-app-key.arn

  rotation_rules {
    schedule_expression = "cron(0 /4 * * ? *)"
  }
}
