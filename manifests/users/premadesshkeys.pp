# Class: trivial_resources::users::premadesshkeys
#
# This helper class manages user accounts for ::users
#
class trivial_resources::users::premadesshkeys {
  $all_resources = parseyaml(template("${module_name}/parse_user_ssh_keys_premade.erb"))
  $all_resources.each | String $resource_name, Hash $resource_props | {
    ssh_authorized_key { $resource_name:
      * => $resource_props,
    }
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
