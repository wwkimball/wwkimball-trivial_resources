# Class: trivial_resources::firewall::pre
#
# Executes all pre-application firewall rules.
#
# Actions:
# - Ensures pre-application firewall rules are set as specified
#
# Requires: see metadata.json
#
# Sample Usage:
# See the parent class, trivial_resources::firewall
#
class trivial_resources::firewall::pre {
  # Do nothing unless the firewall module has been loaded
  if defined('firewall') {
    pick($trivial_resources::fw_pre_rules, {}).each |
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

