# Class: trivial_resources::users::accounts
#
# This helper class manages user accounts for ::users
#
# Parameters:  See trivial_resources::users
#
# Actions:
# - Creates all user accounts as specified in normalUsers[userName...]
#
# Requires: see metadata.json
#
# Sample Usage:  See trivial_resources::users
#
class trivial_resources::users::accounts {
  # Pull out all the users without any of the custom attributes that are used
  # by this class.
  $justUsers = parseyaml(inline_template('<%=
justUsers = {}

# Pull out all users without any of the custom attributes that this class
# enables.  Ensure that a home directory is specified and managed lest Puppet
# create home-less users.
scope.lookupvar("trivial_resources::users::normalUsers").each{|userName, userProps|
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

  if userProps
    justUsers[userName] = userProps.clone
    justUsers[userName].delete("sshAuthorizedKeys")
    justUsers[userName].delete("sshGeneratedKeys")
  else
    justUsers[userName] = {}
  end

  # Puppet will normally define but not create users
  if !justUsers[userName]["ensure"]
    justUsers[userName]["ensure"] = "present"
  end

  # Puppet must manage the home directory
  if !justUsers[userName]["home"]
    justUsers[userName]["home"] = userHome
  end
  justUsers[userName]["managehome"] = true
}

# Send the result back to Puppet
justUsers.to_yaml
  %>'))
  create_resources(user, $justUsers)
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
