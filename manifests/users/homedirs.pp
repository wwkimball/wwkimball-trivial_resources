# Class: trivial_resources::users::homedirs
#
# This helper class manages home directories for ::users
#
# Parameters:  See trivial_resources::users
#
# Actions:
# - Creates all home directories detected at normalUsers[userName...][home]
#
# Requires: see metadata.json
#
# Sample Usage:  See trivial_resources::users
#
class trivial_resources::users::homedirs {
  # Parse out all of the home directories of each users.
  $allHomeDirs = parseyaml(inline_template('<%=
allHomeDirs = {}
flatPaths = []
homeOwners = {}

# Pull out all home directories.  The result must be unique.  We must also keep
# track of which user must own each of these resources.  We do not need to be
# concerned with the parent directories of these home directories because they
# have already been managed before this subclass is called.
scope.lookupvar("trivial_resources::users::normalUsers").each{|userName, userProps|
  # Skip deleted users
  if userProps and userProps["ensure"] and userProps["ensure"] != "present"
    next
  end

  # Identify each default or given home directory
  userHome = ""
  if userProps and userProps["home"]
    userHome = userProps["home"]
  else
    userHome = "/home/#{userName}"
    if userName == "root"
      userHome = "/root"
    end
  end

  flatPaths = flatPaths | [ userHome ]
  homeOwners[userHome] = userName
}

# Convert the flat Array to a Hash and ensure these are directories.
flatPaths.each{|homeDir|
  resourceOwner = fileOwners[homeDir]

  allHomeDirs[homeDir] = {
    "ensure"  => "directory",
    "owner"   => resourceOwner,
    "group"   => resourceOwner,
    "mode"    => "0750"
  }
}

# Send the result back to Puppet
allHomeDirs.to_yaml
  %>'))
  create_resources(file, $allHomeDirs)
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
