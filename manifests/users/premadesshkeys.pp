# Class: trivial_resources::users::premadesshkeys
#
# This helper class manages user accounts for ::users
#
# Parameters:  See trivial_resources::users
#
# Actions:
# - Installs predefined SSH keys for each user, if supplied at
#   normalUsers[userName...][sshAuthorizedKeys]
#
# Requires: see metadata.json
#
# Sample Usage:  See trivial_resources::users
#
class trivial_resources::users::premadesshkeys {
  $allPremadeKeys = parseyaml(template("%{module_name}/transform_user_premadesshkeys.erb"))
  create_resources(ssh_authorized_key, $allPremadeKeys)
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
