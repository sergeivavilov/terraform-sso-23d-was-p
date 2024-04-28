variable "group_name" {
  type = string
}

variable "group_description" {
  type = string
}

variable "identity_store_id" {
  type = string
}

variable "member_ids_map" {
  type = map(string)
}

# Create Group
resource "aws_identitystore_group" "group" {
  identity_store_id = var.identity_store_id
  display_name      = var.group_name
  description       = var.group_description
}

# Create Group Memberships
resource "aws_identitystore_group_membership" "membership" {
  for_each = var.member_ids_map

  identity_store_id = var.identity_store_id
  group_id          = aws_identitystore_group.group.group_id
  member_id         = each.value
}
