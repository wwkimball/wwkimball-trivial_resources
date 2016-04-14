# Class: trivial_resources::firewall
#
# This class provides generic data-driven control over the system firewall, as
# enabled by the puppetlabs-firewall module.  Specially-formed Hash values are
# used to provide all rules.
#
# Parameters:
# - applicationRules:  # A Hash with structure (evaluated after preRules and before postRules):
#     'ordinal rule name...':
#       <<: Non-dependency (requires/before/after/notify/etc.) attributes at
#         https://github.com/puppetlabs/puppetlabs-firewall#type-firewall (Parameters)
# - postRules:  # A Hash with structure (evaluated after preRules and applicationRules):
#     'ordinal rule name...':
#       <<: Non-dependency (requires/before/after/notify/etc.) attributes at
#         https://github.com/puppetlabs/puppetlabs-firewall#type-firewall (Parameters)
# - preRules:  # A Hash with structure (evaluated before applicationRules and postRules):
#     'ordinal rule name...':
#       <<: Non-dependency (requires/before/after/notify/etc.) attributes at
#         https://github.com/puppetlabs/puppetlabs-firewall#type-firewall (Parameters)
#
# Actions:  see each sublcass
#
# Requires: see metadata.json
#
# Sample Usage:
# This class is called and configured via Hiera.  Minimalist Hiera-YAML example:
#   ---
#   classes:
#     - firewall
#     - trivial_resources
#
#   trivial_resources::firewall::applicationRules:
#     '100 accept ssh from subnet':
#       action: accept
#       proto: tcp
#       dport: 22
#       source: 192.168.0.0/16
#     '101 accept all http/s':
#       action: accept
#       proto: tcp
#       dport:
#         - 80
#         - 443
#
class trivial_resources::firewall {
  # Attempt to merge all parameter hash values across the configuration
  # hierarchy.  This is not using the automatic parameter lookup pattern due to:
  # https://tickets.puppetlabs.com/browse/HI-118
  # http://grokbase.com/t/gg/puppet-firewall/13ayxyyxmz/merge-behavior-deeper-and-hiera-hash
  # https://docs.puppetlabs.com/hiera/1/lookup_types.html#priority-default
  $applicationRules = hiera_hash('trivial_resources::firewall::applicationRules', {})
  $postRules = hiera_hash('trivial_resources::firewall::postRules', {})
  $preRules = hiera_hash('trivial_resources::firewall::preRules', {})

  # Sequence the subclasses
  class { 'trivial_resources::firewall::purge': }
  -> class { 'trivial_resources::firewall::pre': }
  -> class { 'trivial_resources::firewall::application': }
  -> class { 'trivial_resources::firewall::post': }
  -> Class['trivial_resources::firewall']
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
