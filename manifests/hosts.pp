# Class: trivial_resources::hosts
#
# This class generically manages the hosts file for each registered host in the
# present environment.
#
# @example
#   ---
#   classes:
#     - trivial_resources
#
#   trivial_resources::hosts::records:
#     db.domain.tld:
#       ip: 192.168.0.100
#       host_aliases:
#         - mysql.network.tld
#     ldap.domain.tld:
#       ip: 192.168.0.101
#       host_aliases: directory
#     dead-host.domain.tld:
#       ensure: absent
#
class trivial_resources::hosts(
  Hash[String, Hash] $resources,
) {
  pick($resources, {}).each | String $resource_name, Hash $resource_props | {
    host { $resource_name:
      * => $resource_props,
    }
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
