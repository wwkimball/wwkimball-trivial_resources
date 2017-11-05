# Class: trivial_resources::users::homes
#
# This helper class manages home directories for ::users
#
class trivial_resources::users::homes {
  $all_resources = parseyaml(template("${module_name}/parse_user_home_parent_directories.erb"))
  $all_resources.each | String $resource_name, Hash $resource_props | {
    file { $resource_name:
      * => $resource_props,
    }
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
