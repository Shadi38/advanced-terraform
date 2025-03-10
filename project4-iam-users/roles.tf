locals {
  role_policies={
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
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = [ "sts:AssumeRole" ]
    principals {
      type = "AWS"
      identifiers = [ "" ]
    }
  }
}

resource "aws_iam_role" "roles" {
  for_each = toset(key(local.role_policies))
  name = each.key
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}