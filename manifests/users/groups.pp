# Class: trivial_resources::users::groups
#
# This helper class manages groups for ::users
#
# NOTE:  Groups defined in the groups member of normalUsers and systemUsers are
# allowed to be hashes, with all the configuration permissible via
# https://docs.puppet.com/puppet/latest/reference/type.html#group.  However, any
# conflicting configuration discovered will cause an error.
#
class trivial_resources::users::groups {
  $all_resources = parseyaml(template("${module_name}/parse_user_groups.erb"))
  $all_resources.each | String $resource_name, Hash $resource_props | {
    # Users can be added to groups that are managed elsewhere
    if !defined(Group[$resource_name]) {
	    group { $resource_name:
	      * => $resource_props,
	    }
    } else {
      # However, ensure any additional attributes are applied as requested
      Group <| title == $resource_name |> {
        * => $resource_props,
      }
    }
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
