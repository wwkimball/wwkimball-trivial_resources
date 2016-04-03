# Class: trivial_resources::users::premadesshkeys
#
# This helper class manages user accounts for ::users
#
# Parameters:  See trivial_resources::users
#
# Actions:
# - Installs predefined SSH keys for each user, if supplied at
#   normalUsers[userName...][sshAuthorizedKeys]
#
# Requires: see metadata.json
#
# Sample Usage:  See trivial_resources::users
#
class trivial_resources::users::premadesshkeys {
  # Parse the allUsers Hash to find all ssh_authorized_key records, appending
  # the correct resource and user names to each.
  $allPremadeKeys = parseyaml(inline_template('<%=
allPremadeKeys = {}

# Hiera will have already ensured these are unique per user, so this pass can be
# more lax.
scope.lookupvar("trivial_resources::users::normalUsers").each{|userName, userProps|
  # Skip deleted users
  if userProps and userProps["ensure"] and userProps["ensure"] != "present"
    next
  end

  if userProps and userProps["sshAuthorizedKeys"]
    userProps["sshAuthorizedKeys"].each{|keyName, keyProps|
      resourceName = userName + "_" + keyName
      allPremadeKeys[resourceName] = keyProps
      allPremadeKeys[resourceName]["user"] = userName
    }
  end
}

allPremadeKeys.to_yaml
  %>'))
  create_resources(ssh_authorized_key, $allPremadeKeys)
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
