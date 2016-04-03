# Class: trivial_resources::users::sshdirs
#
# This helper class manages user accounts for ::users
#
# Parameters:  See trivial_resources::users
#
# Actions:
# - Creates all .ssh directories for all users at normalUsers[userName...]
#
# Requires: see metadata.json
#
# Sample Usage:  See trivial_resources::users
#
class trivial_resources::users::sshdirs {
  # Now that all the user accounts exist, repeat the "ensure all
  # home-directories exist" exercise to also ensure all these users' .ssh
  # directories exist.  These won't need special splitting treatment because
  # all parent directories have already been handled.
  $allSSHDirs = parseyaml(inline_template('<%=
allSSHDirs = {}
flatPaths = []
pathOwners = {}

# Pull out all home directories and append .ssh to them.  The result must be
# unique.  Because Windows has permitted mixed handling of \ and / for a very
# long time, Puppet also permits mixing them together.  As such, only use / for
# this to safely handle both Windows and *nix (including OSX).  We must also
# keep track of which user must own each of these directories.
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
  pathOwners[sshDir] = userName
}

# Convert the flat Array to a Hash and ensure these are private directories.
flatPaths.each{|homeDir|
  resourceOwner = pathOwners[homeDir]

  allSSHDirs[homeDir] = {
    "ensure"  => "directory",
    "owner"   => resourceOwner,
    "group"   => resourceOwner,
    "mode"    => "0700"
  }
}

# Send the result back to Puppet
allSSHDirs.to_yaml
  %>'))
  create_resources(file, $allSSHDirs)
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
