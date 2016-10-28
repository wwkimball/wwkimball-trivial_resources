# Class: trivial_resources::users::homedirs
#
# This helper class manages home directories for ::users
#
# Parameters:  See trivial_resources::users
#
# Actions:
# - Creates all home directories detected at normalUsers[userName...][home]
#
# Requires: see metadata.json
#
# Sample Usage:  See trivial_resources::users
#
class trivial_resources::users::homedirs {
  $allHomeDirs = parseyaml(template("${module_name}/transform_user_homedirs.erb"))
  create_resources(file, $allHomeDirs)
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
