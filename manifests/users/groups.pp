# Class: trivial_resources::users::groups
#
# This helper class manages groups for ::users
#
# Parameters:  See trivial_resources::users
#
# Actions:
# - Creates all groups that are detected in normalUsers[userName...][groups]
#
# Requires: see metadata.json
#
# Sample Usage:  See trivial_resources::users
#
class trivial_resources::users::groups {
  # Parse the allUsers Hash to find all group name values, create a new Hash
  # from them, and ensure all the discovered groups exist so that data authors
  # won't need to duplicate this data.
  $allGroups = parseyaml(inline_template('<%=
allGroups = {}
flatGroups = []

# Pull out all groups.  The result must be unique.
scope.lookupvar("trivial_resources::users::normalUsers").each{|userName, userProps|
  # Skip deleted users
  if userProps and userProps["ensure"] and userProps["ensure"] != "present"
    next
  end

  if userProps and userProps["groups"]
    flatGroups = flatGroups | userProps["groups"]
  end
}

# Convert the flat Array to a Hash
flatGroups.each{|groupName|
  allGroups[groupName] = {
    "ensure"  => "present"
  }
}

# Send the result back to Puppet
allGroups.to_yaml
  %>'))
  create_resources(group, $allGroups)
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
