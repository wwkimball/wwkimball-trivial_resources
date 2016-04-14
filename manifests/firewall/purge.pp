# Class: trivial_resources::firewall::purge
#
# Ensures that all firewall rules are Puppet manged, purging all unmanaged
# rules.
#
# Actions:
# - Purges all non-Puppet-defined firewall rules
#
# Requires: see metadata.json
#
# Sample Usage:
# See the parent class, trivial_resources::firewall
#
class trivial_resources::firewall::purge {
  # Do nothing unless the firewall module has been loaded
  if defined('firewall') {
    resources { 'firewall':
      purge => true,
    }

    # Causes error:  Invalid argument. Run `dmesg' for more information.
    #resources { 'firewallchain':
    #  purge => true,
    #}
  }
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
