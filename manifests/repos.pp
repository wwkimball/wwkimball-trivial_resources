# Class: trivial_resources::repos
#
# This class generically manages repository configuration files.
#
# @example
#   ---
#   classes:
#     - trivial_resources
#
#   trivial_resources::repos::yum:
#     my-nexus-repository:
#       baseurl: http://nexus.domain.tld:8080/nexus/content/repositories/my-repository
#       enabled: 1
#       gpgcheck: 0
#     dead-repository:
#       ensure: absent
#
class trivial_resources::repos(
  Optional[Hash[String, Hash]] $yum = undef,
) {
  pick($yum, {}).each | String $resource_name, Hash $resource_props | {
    yumrepo { $resource_name:
      * => $resource_props,
    }
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
