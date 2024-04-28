data "aws_ssoadmin_instances" "primary" {}

# any locals if necessary, ex: for identity_store_id
locals {
  sso_store_id = tolist(data.aws_ssoadmin_instances.primary.identity_store_ids)[0]
}

# Create users from csv file
module "sso_users_23d" {
  source            = "../sso-users"
  csv_file_path     = "23d_aws_access.csv"
  identity_store_id = local.sso_store_id
}

# Create group for 23D
module "sso_group_23d" {
  source            = "../sso-group"
  group_name        = "DevOps-23d"
  group_description = "23D Batch"
  identity_store_id = local.sso_store_id
  member_ids_map    = module.sso_users_23d.member_ids

  depends_on = [module.sso_users_23d]
}

# output "display_member_ids" {
#   value = module.sso_users_23d.member_ids
# }