# Class: trivial_resources::tidies
#
# This class generically manages tidy rules, which delete aging files and
# directories.
#
# Parameters:
# - tidyRules:  A hash of rule definitions based on
#   https://docs.puppetlabs.com/puppet/latest/reference/type.html#tidy
#   excluding all resource dependency attributes (before/after/require/notify).
#
# Actions:
# - Ensures the specified tidy rules are defined
#
# Requires: see metadata.json
#
# Sample Usage:
# This class is called and configured via Hiera.  Minimalist Hiera-YAML example:
#   ---
#   classes:
#     - trivial_resources
#
#   trivial_resources::tidies::tidyRules:
#     '/tmp':
#       age: 2w
#       recurse: true
#       rmdirs: true
#
class trivial_resources::tidies {
  $tidyRules = hiera_hash('trivial_resources::tidies::tidyRules', {})
  create_resources(tidy, $tidyRules)
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
