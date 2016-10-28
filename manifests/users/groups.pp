# Class: trivial_resources::users::groups
#
# This helper class manages groups for ::users
#
# NOTE:  Groups defined in the groups member of normalUsers and systemUsers are
# allowed to be hashes, with all the configuration permissible via
# https://docs.puppet.com/puppet/latest/reference/type.html#group.  However, any
# conflicting configuration discovered will cause an error.
#
# Parameters:  See trivial_resources::users
#
# Actions:
# - Creates all groups that are detected in normalUsers[userName...][gid] (when
#   a name is provided rather than a number), normalUsers[userName...][groups],
#   systemUsers[userName...][gid] (when a name is provided rather than a
#   number), and systemUsers[userName...][groups].
#
# Requires: see metadata.json
#
# Sample Usage:  See trivial_resources::users
#
class trivial_resources::users::groups {
  $allGroups = parseyaml(template("%{module_name}/transform_user_groups.erb"))
  create_resources(group, $allGroups)
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
