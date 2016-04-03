# Class: trivial_resources::hosts
#
# This class generically manages the hosts file for each registered host in the
# present environment.
#
# Parameters:
# - hostsMap:  A hash of host IPs and their aliases based on
#   https://docs.puppetlabs.com/references/latest/type.html#host; default =
#   localhost:
#     ip: 127.0.0.1
#     host_aliases:
#       - localhost.localdomain
#       - localhost4
#       - localhost4.localdomain4
#       - "%{::hostname}"
#       - "%{::fqdn}"
#   localhost6:
#     ip: "::1"
#     host_aliases:
#       - localhost6.localdomain6
#
# Actions:
# - Ensures required application and data directories exist.
#
# Requires: see metadata.json
#
# Sample Usage:
# This class is called and configured via Hiera.  Minimalist Hiera-YAML example:
#   ---
#   classes:
#     - trivial_resources
#
#   trivial_resources::hosts::hostsMap:
#     db.network.tld:
#       ip: 10.20.30.1
#       host_aliases:
#         - vca.network.tld
#         - vertica.network.tld
#         - analytics.network.tld
#     ldap.network.tld:
#       ip: 10.20.30.2
#       host_aliases: directory
#     dead-host.network.tld:
#       ensure: absent
#
class trivial_resources::hosts {
  # Attempt to merge all specified hostsMap values across the configuration
  # hierarchy.  This is not using the automatic parameter lookup pattern due to:
  # https://tickets.puppetlabs.com/browse/HI-118
  # http://grokbase.com/t/gg/puppet-users/13ayxyyxmz/merge-behavior-deeper-and-hiera-hash
  # https://docs.puppetlabs.com/hiera/1/lookup_types.html#priority-default
  $hostsMap = hiera_hash('trivial_resources::hosts::hostsMap', {})

  # The claim on multiple variations of 'localhost' by IPv4 and IPv6 causes some
  # applications to become severely confused and even the host itself has been
  # seen losing touch with its correct domain.  This module reduces the set down
  # to just one unified localhost record to end this confusion.
  host { [
    'localhost.localdomain',
    'localhost4',
    'localhost4.localdomain4',
    'localhost6.localdomain6',
  ]:
    ensure  => absent,
  }

  create_resources(host, $hostsMap)
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
