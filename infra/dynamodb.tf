resource "aws_dynamodb_table" "this" {
  name             = "tb_application_keys_to_expire"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "appkey_id"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "appkey_id"
    type = "S"
  }

  ttl {
    attribute_name = "expire_at"
    enabled        = true
  }
}
