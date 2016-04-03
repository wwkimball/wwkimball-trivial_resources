# Class: trivial_resources::users::parentdirs
#
# This helper class manages parent directories of the home directories for
# ::users
#
# Parameters:  See trivial_resources::users
#
# Actions:
# - Creates all parent directories for the home directories detected at
#   normalUsers[userName...][home]
#
# Requires: see metadata.json
#
# Sample Usage:  See trivial_resources::users
#
class trivial_resources::users::parentdirs {
  # Parse out all of the parent directories of each users' home directory.
  $allParentDirs = parseyaml(inline_template('<%=
allParentDirs = {}
flatPaths = []

# Pull out all directories that are parents of the actual user home directories
# by splitting them apart using the pltraining/dirtree function.  The result
# must be unique.
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

  scope.function_dirtree([userHome, "/home"]).each{|homePart|
    flatPaths = flatPaths | [ homePart ]
  }
  flatPaths.delete(userHome)
}

# Convert the flat Array to a Hash and ensure these are directories.
flatPaths.each{|homeDir|
  allParentDirs[homeDir] = {
    "ensure"  => "directory"
  }
}

# Send the result back to Puppet
allParentDirs.to_yaml
  %>'))
  create_resources(file, $allParentDirs)
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
