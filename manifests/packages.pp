# Class: trivial_resources::packages
#
# This subclass manages a Hiera-defined collection of packages.
#
# Parameters:  see init.pp
#
# Actions:
# - Manages the Hiera-defined packages as specified in the configuration data.
#
# Requires: see init.pp
#
# Sample Usage: see init.pp
#
class trivial_resources::packages {
  pick($trivial_resources::packages, {}).each |
    String               $resource_name,
    Hash[String[2], Any] $resource_props,
  | {
    package {
      default:        *=> $trivial_resources::package_defaults,;
      $resource_name: *=> $resource_props,;
    }
  }
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
