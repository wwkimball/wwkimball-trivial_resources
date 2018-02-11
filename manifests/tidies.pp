# Class: trivial_resources::tidies
#
# This class generically manages tidy rules, which delete aging files and
# directories.
#
# Parameters:
# - tidy_rules:  A hash of rule definitions based on
#   https://docs.puppetlabs.com/puppet/latest/reference/type.html#tidy
#   excluding all resource dependency attributes (before/after/require/notify).
#
# Actions:
# - Ensures the specified tidy rules are defined
#
# Requires: see init.pp
#
# Sample Usage:
# ---
# classes:
#   - trivial_resources
#
# trivial_resources::tidy_rules:
#   '/tmp':
#     age: 2w
#     recurse: 1
#     rmdirs: true
#
class trivial_resources::tidies(
  Hash[String, Any]  $defaults,
  Hash[String, Hash] $resources,
) {
  pick($resources, {}).each |
    String $resource_name,
    Hash   $resource_props,
  | {
    tidy {
      default:        *=> $defaults;
      $resource_name: *=> $resource_props;
    }
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
