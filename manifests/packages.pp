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
  # Attempt to merge all specified package hash values across the configuration
  # hierarchy.  This is not using the automatic parameter lookup pattern due to:
  # https://tickets.puppetlabs.com/browse/HI-118
  # http://grokbase.com/t/gg/puppet-users/13ayxyyxmz/merge-behavior-deeper-and-hiera-hash
  # https://docs.puppetlabs.com/hiera/1/lookup_types.html#priority-default
  $packageConfig = hiera_hash('trivial_resources::packages::packageConfig', {})

  # Ensure a default ensure state is always present.
  $ensuredPackages = parseyaml(inline_template('<%=
ensuredPackages = {}

@packageConfig.each{|packageName, packageProps|
  if packageProps
    ensuredPackages[packageName] = packageProps.clone
  else
    ensuredPackages[packageName] = {}
  end

  # Puppet will normally define but not create packages
  if !ensuredPackages[packageName]["ensure"]
    ensuredPackages[packageName]["ensure"] = "present"
  end
}

# Send the result back to Puppet
ensuredPackages.to_yaml
  %>'))

  create_resources(package, $ensuredPackages)
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai