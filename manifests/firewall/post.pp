# Class: trivial_resources::firewall::post
#
# Executes all post-application firewall rules.
#
# Actions:
# - Ensures post-application firewall rules are set as specified
#
# Requires: see metadata.json
#
# Sample Usage:
# See the parent class, trivial_resources::firewall
#
class trivial_resources::firewall::post {
  # Do nothing unless the firewall module has been loaded
  if defined('firewall') {
    pick($trivial_resources::fw_post_rules, {}).each |
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
