# Class: trivial_resources::users::accounts
#
# This helper class manages user accounts for ::users
#
# Parameters:  See trivial_resources::users
#
# Actions:
# - Creates all user accounts as specified in normalUsers[userName...]
#
# Requires: see metadata.json
#
# Sample Usage:  See trivial_resources::users
#
class trivial_resources::users::accounts {
  $justUsers = parseyaml(template("%{module_name}/transform_user_accounts.erb"))
  create_resources(user, $justUsers)
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
