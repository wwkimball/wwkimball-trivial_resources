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
    pick($trivial_resources::fw_app_rules, {}).each |
      String $resource_name,
      Hash   $resource_props,
    | {
      firewall {
        default:        *=> $trivial_resources::fw_rule_defaults;
        $resource_name: *=> $resource_props;
      }
    }
  }
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
