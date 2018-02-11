# Class: trivial_resources::mounts
#
# This class provides a generic means of managing mount-points on hosts that
# support them.
#
# @example
#   ---
#   classes:
#     - trivial_resources
#
class trivial_resources::mounts(
  Hash[String, Any]  $defaults,
  Hash[String, Hash] $resources,
) {
  pick ($resources, {}).each | String $resource_name, Hash $resource_props | {
    mount {
      default:        *=> $defaults,;
      $resource_name: *=> $resource_props,;
    }
  }
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
