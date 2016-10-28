# Class: trivial_resources::users::groups
#
# This helper class manages groups for ::users
#
# NOTE:  Groups defined in the groups member of normalUsers and systemUsers are
# allowed to be hashes, with all the configuration permissible via
# https://docs.puppet.com/puppet/latest/reference/type.html#group.  However, any
# conflicting configuration discovered will cause an error.
#
# Parameters:  See trivial_resources::users
#
# Actions:
# - Creates all groups that are detected in normalUsers[userName...][gid] (when
#   a name is provided rather than a number), normalUsers[userName...][groups],
#   systemUsers[userName...][gid] (when a name is provided rather than a
#   number), and systemUsers[userName...][groups].
#
# Requires: see metadata.json
#
# Sample Usage:  See trivial_resources::users
#
class trivial_resources::users::groups {
  # Parse the users Hashes to find all group name values, create a new Hash
  # from them, and ensure all the discovered groups exist so that data authors
  # won't need to duplicate this data.
  $allGroups = parseyaml(inline_template('<%=
def addPlainGroup(groupName, groupContainer)
  # Accept only strings
  if !groupName.is_a?(String)
    return false
  end

  # Convert weird "stringy" values to bona fide strings
  safeName = groupName.to_s

  # Check for a group presence conflict
  if groupContainer.has_key?(safeName)
    if groupContainer[safeName]["ensure"] != "present"
      fail("User group [#[safeName]] cannot be both [present] and [#{groupContainer[safeName]["ensure"]}].  You must eliminate this conflict in your user data.")
    end
  else
    groupContainer[safeName] = {
      "ensure" => "present"
    }
  end

  return true
end

def addComplexGroup(groupHash, groupContainer)
  # Accept only a Hash
  if groupHash.nil? or groupHash.empty? or !groupHash.is_a?(Hash)
    return false
  end

  groupName = groupHash.keys.first
  groupProps = groupHash.values.first

  # Accept only string names
  if !groupName.is_a?(String)
    return false
  end

  # Convert weird "stringy" values to bona fide strings
  safeName = groupName.to_s
  if !groupContainer.has_key?(safeName)
    groupContainer[safeName] = groupProps

    # Ensure the group is created, if not explicitly set
    if !groupContainer[safeName]["ensure"]
      groupContainer[safeName]["ensure"] = "present"
    end
  else
    # Group is already defined; check for conflicts
    savedGroup = groupContainer[safeName]
    groupProps.each{|propKey, propVal|
      if savedGroup.has_key?(propKey)
        if savedGroup[propKey] != propVal
          fail("Key [#{propKey}] of user group [#{safeName}] has been assigned both [#{savedGroup[propKey]}] and [#{propVal}] as values.  This is not allowed because the processing order of your user data is unpredicable at run-time, leading to an unreliable state.  You must eliminate this conflict in your user data.")
        end
      else
        groupContainer[safeName][propKey] = propVal
      end
    }
  end

  return true
end

def extractGroups(userHash, groupContainer)
  # Accept only a Hash
  if userHash.nil? or !userHash.is_a?(Hash)
    return false
  end

  userHash.each{|userName, userProps|
    # Skip deleted users
    if userProps and userProps["ensure"] and userProps["ensure"] != "present"
      next
    end

    if userProps
      # Include named primary groups (non-numeric GIDs)
      if userProps["gid"]
        addPlainGroup(userProps["gid"], groupContainer)
      end

      # The groups element may be a string, integer, or Array
      if userProps["groups"]
        userGroups = userProps["groups"]

        if userGroups.kind_of?(Array)
          userGroups.each{|userGroup|
            # Each entry may be a string, integer, or Hash
            if userGroup.is_a?(Hash)
              addComplexGroup(userGroup, groupContainer)
            else
              addPlainGroup(userGroup, groupContainer)
            end
          }
        else
          addPlainGroup(userGroups, groupContainer)
        end
      end
    end
  }

  return true
end

# Pull out all groups.  The result must be unique.
allGroups = {}
extractGroups(scope.lookupvar("trivial_resources::users::normalUsers"), allGroups)
extractGroups(scope.lookupvar("trivial_resources::users::systemUsers"), allGroups)

# Send the result back to Puppet
allGroups.to_yaml
  %>'))
  create_resources(group, $allGroups)
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
