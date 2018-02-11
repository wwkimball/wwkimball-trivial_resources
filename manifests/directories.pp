# Class: trivial_resources::directories
#
# This subclass manages a Hiera-defined collection of directories.
#
# Parameters:  see init.pp
#
# Actions:
# - Manages the Hiera-defined directories as specified in the configuration data.
#
# Requires: see init.pp
#
# Sample Usage: see init.pp
#
class trivial_resources::directories(
  Hash[String, Any]  $defaults,
  Hash[String, Hash] $resources,
) {
  pick($resources, {}).each |
    String               $resource_name,
    Hash[String[2], Any] $resource_props,
  | {
    file {
      default:
        * => $defaults,;

      $resource_name:
        ensure => directory,
        *      => $resource_props,;
    }
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
