# Class: trivial_resources::repos
#
# This class generically manages repository configuration files.
#
# Parameters:
# - yumRepos:  A hash of yum repository definitions based on
#   http://docs.puppetlabs.com/references/latest/type.html#yumrepo; no default
#
# Actions:
# - Ensures the specified repositories are defined
#
# Requires: see metadata.json
#
# Sample Usage:
# This class is called and configured via Hiera.  Minimalist Hiera-YAML example:
#   ---
#   classes:
#     - trivial_resources
#
#   trivial_resources::repos::yumRepos:
#     my-nexus-repository:
#       baseurl: http://nexus.domain.tld:8080/nexus/content/repositories/my-repository
#       enabled: true
#       gpgcheck: false
#     dead-repository:
#       ensure: absent
#
class trivial_resources::repos {
  # Attempt to merge all specified repo hash values across the configuration
  # hierarchy.  This is not using the automatic parameter lookup pattern due to:
  # https://tickets.puppetlabs.com/browse/HI-118
  # http://grokbase.com/t/gg/puppet-users/13ayxyyxmz/merge-behavior-deeper-and-hiera-hash
  # https://docs.puppetlabs.com/hiera/1/lookup_types.html#priority-default
  $yumRepos = hiera_hash('trivial_resources::repos::yumRepos', {})
  create_resources(yumrepo, $yumRepos)
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
