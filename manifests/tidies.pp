# Class: trivial_resources::tidies
#
# This class generically manages tidy rules, which delete aging files and
# directories.
#
# Parameters:  see init.pp
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
class trivial_resources::tidies {
  pick($trivial_resources::tidy_rules, {}).each |
    String $resource_name,
    Hash   $resource_props,
  | {
    tidy {
      default:        *=> $trivial_resources::tidy_rule_defaults;
      $resource_name: *=> $resource_props;
    }
  }
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
