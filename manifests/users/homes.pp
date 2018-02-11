# Class: trivial_resources::users::homes
#
# This helper class manages home directories for ::users
#
class trivial_resources::users::homes {
  $all_resources = parseyaml(template("${module_name}/parse_user_home_parent_directories.erb"))
  $all_resources.each | String $resource_name, Hash $resource_props | {
    # Don't redefine directories that have already been added elsewhere to the
    # manifest.  This most often occurs when the caller has defined the home
    # directories via trivial_resources::directories, which overrides this.
    if !defined(File[$resource_name]) {
      file { $resource_name:
        * => $resource_props,
      }
    }
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
