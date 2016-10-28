# Class: trivial_resources::packages
#
# This module manages a Hiera-defined collection of packages.
#
# Parameters:
# - packageConfig: A Hash defining the names and Puppet-specific options which
#   define the packages to control.
#
# Actions:
# - Manages the Hiera-defined packages as specified in the configuration data.
#
# Requires: see metadata.json
#
# Sample Usage: See each subclass of this module for configuration samples.
# This class is called and configured via Hiera.  Minimalist Hiera-YAML example:
#   ---
#   classes:
#     - trivial_resources
#
#   trivial_resources::packages::packageConfig:
#     required-package:   # Like:  unzip
#     pinned-package:     # Like:  zip
#       ensure: 4.0.19-1.el6
#     bad-package:        # Like:  rootkit  (if it were an RPM package)
#       ensure: absent
#
class trivial_resources::packages {
  $packageConfig = hiera_hash('trivial_resources::packages::packageConfig', {})
  $ensuredPackages = parseyaml(template("${module_name}/transform_packages.erb"))
  create_resources(package, $ensuredPackages)
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
