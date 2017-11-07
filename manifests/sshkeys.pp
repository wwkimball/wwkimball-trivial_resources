# Class: trivial_resources::sshkeys
#
# This class generically manages sshkey entries in the host's shared key-store.
#
# @example
#   ---
#   classes:
#     - trivial_resources::sshkeys
#
#   trivial_resources::sshkeys::yum:
#     my-nexus-sshkeysitory:
#       baseurl: http://nexus.domain.tld:8080/nexus/content/sshkeysitories/my-sshkeysitory
#       enabled: 1
#       gpgcheck: 0
#     dead-sshkeysitory:
#       ensure: absent
#
class trivial_resources::sshkeys(
  Hash[String, Hash] $resources,
) {
  pick($resources, {}).each | String $resource_name, Hash $resource_props | {
    sshkey { $resource_name:
      * => $resource_props,
    }
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
