# Class: trivial_resources::users::sshcontrolfiles
#
# This helper class manages user accounts for ::users
#
# Parameters:  See trivial_resources::users
#
# Actions:
# - Creates standard SSH control files for all users at normalUsers[userName...]
#
# Requires: see metadata.json
#
# Sample Usage:  See trivial_resources::users
#
class trivial_resources::users::sshcontrolfiles {
  # And now that all the .ssh directories exist, add all of the standard SSH
  # control files.
  $allSSHControlFiles = parseyaml(template("%{module_name}/transform_user_sshcontrolfiles.erb"))
  create_resources(file, $allSSHControlFiles)
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
