# Class: trivial_resources::users::parentdirs
#
# This helper class manages parent directories of the home directories for
# ::users
#
# Parameters:  See trivial_resources::users
#
# Actions:
# - Creates all parent directories for the home directories detected at
#   normalUsers[userName...][home]
#
# Requires: see metadata.json
#
# Sample Usage:  See trivial_resources::users
#
class trivial_resources::users::parentdirs {
  $allParentDirs = parseyaml(template("${module_name}/transform_user_parentdirs.erb"))
  create_resources(file, $allParentDirs)
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
