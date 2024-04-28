variable "csv_file_path" {
  description = "Path to the CSV file containing user data"
  type        = string
  default     = "employees_with_aws_access.csv"
}

locals {
  users = csvdecode(file(var.csv_file_path))
}

variable "identity_store_id" {
  type = string
}

resource "aws_identitystore_user" "sso_user" {
  # repeat this resource block for each email in the local.users
  for_each = { for u in local.users : u.email => u }

  identity_store_id = var.identity_store_id

  # Assuming the CSV column names match here
  user_name    = each.value.email
  display_name = "${each.value.firstname} ${each.value.lastname}"
  title        = each.value.title

  name {
    given_name  = each.value.firstname
    family_name = each.value.lastname
  }

  emails {
    value   = each.value.email
    primary = true
  }
}

output "member_ids" {
  value = { for user in aws_identitystore_user.sso_user : user.user_name => user.user_id }
}
