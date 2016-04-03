# Class: trivial_resources
#
# This module manages resources that are too trivial to warrant their own
# full-fledged Puppet modules.
#
# *This class and its subclasses are designed for RedHat-based Linux systems.*
#
# Parameters: none
#
# Actions: see each subclass of this module
#
# Requires: see metadata.json
#
# Sample Usage: See each subclass of this module for configuration samples.
# This class is called and configured via Hiera.  Minimalist Hiera-YAML example:
#   ---
#   classes:
#     - trivial_resources
#
class trivial_resources {
  class { 'trivial_resources::users': }
  -> class { 'trivial_resources::hosts': }
  -> class { 'trivial_resources::repos': }
  -> class { 'trivial_resources::packages': }
  -> Class['trivial_resources']
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
