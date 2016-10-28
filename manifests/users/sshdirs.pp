# Class: trivial_resources::users::sshdirs
#
# This helper class manages user accounts for ::users
#
# Parameters:  See trivial_resources::users
#
# Actions:
# - Creates all .ssh directories for all users at normalUsers[userName...]
#
# Requires: see metadata.json
#
# Sample Usage:  See trivial_resources::users
#
class trivial_resources::users::sshdirs {
  # Now that all the user accounts exist, repeat the "ensure all
  # home-directories exist" exercise to also ensure all these users' .ssh
  # directories exist.  These won't need special splitting treatment because
  # all parent directories have already been handled.
  $allSSHDirs = parseyaml(template("%{module_name}/transform_user_sshdirs.erb"))
  create_resources(file, $allSSHDirs)
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
