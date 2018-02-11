# Class: trivial_resources::users::accounts
#
# This helper class manages user accounts for ::users
#
class trivial_resources::users::accounts {
  $all_resources = parseyaml(template("${module_name}/parse_user_accounts.erb"))
  $all_resources.each | String $resource_name, Hash $resource_props | {
    user { $resource_name:
      * => $resource_props,
    }
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
