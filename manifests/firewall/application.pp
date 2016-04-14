# Class: trivial_resources::firewall::application
#
# Executes all application firewall rules.
#
# Actions:
# - Ensures application firewall rules are set as specified
#
# Requires: see metadata.json
#
# Sample Usage:
# See the parent class, trivial_resources::firewall
#
class trivial_resources::firewall::application {
  # Do nothing unless the firewall module has been loaded
  if defined('firewall') {
    create_resources(firewall, $trivial_resources::firewall::applicationRules)
  }
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
