data "aws_caller_identity" "current" {}

data "aws_vpcs" "this" {}

data "aws_vpc" "this" {
  id = data.aws_vpcs.this.ids[0]
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.this.ids[0]]
  }
}
