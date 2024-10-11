module "iamsr" {
  source = "./_modules/aws-iamsr"

  replacement_vars = {
    account_id = local.account_id
    region     = local.region
  }

  policies = {
    policy-rotate-secret    = "./_iamsr/policies/policy-rotate-secret.tftpl",
    policy-dynamodb-streams = "./_iamsr/policies/policy-dynamodb-streams.tftpl",
  }

  roles = {
    lambda-function-role = {
      trust_role = "./_iamsr/assume_roles/trust-lambda.tftpl"
      policies_attachments = [
        "arn:aws:iam::${local.account_id}:policy/policy-rotate-secret",
        "arn:aws:iam::${local.account_id}:policy/policy-dynamodb-streams"
      ]
    }
  }
}
