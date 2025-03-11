locals {
  role_policies = {
    readonly = [
      "readOnlyAccess"
    ]
    admin = [
      "administratorAccess"
    ]
    auditor = [
      "Securityaudit"
    ]
    developer = [
      "amazonVPCFullAccess",
      "amazonRDSFullAccess",
      "amazonEc2FullAccess"
    ]

  }
  //with faltten(), we get rid of extra [] in our result. look at output
  role_policies_list = flatten([
    for role, policies in local.role_policies : [
      for policy in policies : {
        role   = role
        policy = policy
      }
    ]
  ])
}



data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::575108915407:user/laura"]
    }
  }
}

resource "aws_iam_role" "roles" {
  for_each           = toset(keys(local.role_policies))
  name               = each.key
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

//we shoud get policies that manage by AWS
data "aws_iam_policy" "managed_policies" {
  for_each = toset(local.role_policies_list[*].policy)
  arn      = "arn:aws:iam::aws:policy/${each.value}"
}

//here we attach policies to roles 
resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  count      = length(local.role_policies_list)
  role       = aws_iam_role.roles[local.role_policies_list[count.index].role].name
  policy_arn = data.aws_iam_policy.managed_policies[local.role_policies_list[count.index].policy].arn
}

output "policies" {
  value = local.role_policies_list
}