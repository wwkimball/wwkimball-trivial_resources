# Class: trivial_resources::users::sshcontrolfiles
#
# This helper class manages user accounts for ::users
#
# Parameters:  See trivial_resources::users
#
# Actions:
# - Creates standard SSH control files for all users at normalUsers[userName...]
#
# Requires: see metadata.json
#
# Sample Usage:  See trivial_resources::users
#
class trivial_resources::users::sshcontrolfiles {
  # And now that all the .ssh directories exist, add all of the standard SSH
  # control files.
  $allSSHControlFiles = parseyaml(inline_template('<%=
allSSHControlFiles = {}
flatPaths = []
fileOwners = {}

# Pull out all home directories and append .ssh to them.  The result must be
# unique.  Because Windows has permitted mixed handling of \ and / for a very
# long time, Puppet also permits mixing them together.  As such, only use / for
# this to safely handle both Windows and *nix (including OSX).  We must also
# keep track of which user must own each of these resources.
scope.lookupvar("trivial_resources::users::normalUsers").each{|userName, userProps|
  # Skip deleted users
  if userProps and userProps["ensure"] and userProps["ensure"] != "present"
    next
  end

  # Identify the default or given home directory
  userHome = ""
  if userProps and userProps["home"]
    userHome = userProps["home"]
  else
    userHome = "/home/#{userName}"
    if userName == "root"
      userHome = "/root"
    end
  end

  sshDir = "#{userHome}/.ssh"
  flatPaths = flatPaths | [ sshDir ]
  fileOwners[sshDir] = userName
}

# Convert the flat Array to a Hash and derive all of the standard SSH control
# files.
flatPaths.each{|homeDir|
  resourceOwner = fileOwners[homeDir]
  authKeyFile   = homeDir + "/authorized_keys"

  allSSHControlFiles[authKeyFile] = {
    "ensure"  => "present",
    "owner"   => resourceOwner,
    "group"   => resourceOwner,
    "mode"    => "0600"
  }

  allSSHControlFiles[homeDir + "/authorized_keys2"] = {
    "ensure"  => "link",
    "target"  => authKeyFile,
    "backup"  => true
  }

  allSSHControlFiles[homeDir + "/known_hosts"] = {
    "ensure"  => "present",
    "owner"   => resourceOwner,
    "group"   => resourceOwner,
    "mode"    => "0644"
  }

  allSSHControlFiles[homeDir + "/config"] = {
    "ensure"  => "present",
    "owner"   => resourceOwner,
    "group"   => resourceOwner,
    "mode"    => "0600"
  }
}

# Send the result back to Puppet
allSSHControlFiles.to_yaml
  %>'))
  create_resources(file, $allSSHControlFiles)
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
