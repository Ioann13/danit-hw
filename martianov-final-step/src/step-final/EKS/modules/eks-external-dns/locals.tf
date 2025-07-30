data "aws_region" "current" {}

locals {

  merged_values = yamlencode({
    aws = {
      region         = data.aws_region.current.id
      assumeRoleArn  = var.irsa_assume_role_arn
    }
    rbac = {
      create = var.rbac_create
    }
    serviceAccount = {
      create      = var.service_account_create
      name        = var.service_account_name
      annotations = {
        "eks.amazonaws.com/role-arn" = local.irsa_role_create ? aws_iam_role.this[0].arn : ""
      }
    }
    provider      = "aws"
    policy        = "sync"
    registry      = "txt"
    txtOwnerId    = "danit-devops7"
    awsZoneType   = "public"
    logLevel      = "debug"
    domainFilters = ["test-danit.com"]
  })
}