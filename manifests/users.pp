# Class: trivial_resources::users
#
# This class provides generic data-driven control over system users.  A
# specially-formed Hash is used to collect all user settings.
#
# Parameters:
# - normalUsers:  # A Hash with structure:
#     userName...:
#       <<: Non-dependency (requires/before/after/notify/etc.) attributes at
#         https://docs.puppetlabs.com/puppet/latest/reference/type.html#user
#       <<: NOTE:  Passwords will not be encrypted for you by this module.  It
#           is up to you to properly encrypt your passwords in the Hiera data
#           before calling this class.
#       <<: plus:
#       sshAuthorizedKeys:
#         keyName...:
#           <<: Non-dependency (requires/before/after/notify/etc.) attributes at
#             https://docs.puppetlabs.com/puppet/latest/reference/type.html#sshauthorizedkey
#           <<: except:
#             - Do not specify the `user` attribute; it will be inferred from
#               the parent user.
#
# Actions:  see each sublcass (homes, groups, accounts, etc.)
#
# Requires: see metadata.json
#
# Sample Usage:
# This class is called and configured via Hiera.  Minimalist Hiera-YAML example:
#   ---
#   classes:
#     - trivial_resources
#
#   trivial_resources::users::normalUsers:
#     gwashington:
#       groups:
#         - presidents
#       password:  ENC[PKCS7,AAAhexstringA==]   # EYAML-encoded, pre-encrypted value
#       sshAuthorizedKeys:
#         gWashingtonPublicKey:
#           key:  AAmorehexA==
#           type: rsa2
#     jdoe:
#       groups:
#         - people
#       password:  ENC[PKCS7,AABhexstringC==]   # EYAML-encoded, pre-encrypted value
#
class trivial_resources::users {
  # Attempt to merge all specified user hash values across the configuration
  # hierarchy.  This is not using the automatic parameter lookup pattern due to:
  # https://tickets.puppetlabs.com/browse/HI-118
  # http://grokbase.com/t/gg/puppet-users/13ayxyyxmz/merge-behavior-deeper-and-hiera-hash
  # https://docs.puppetlabs.com/hiera/1/lookup_types.html#priority-default
  $normalUsers = hiera_hash('trivial_resources::users::normalUsers', {})

  # Sequence the subclasses
  class { 'trivial_resources::users::parentdirs': }
  -> class { 'trivial_resources::users::groups': }
  -> class { 'trivial_resources::users::accounts': }
  -> class { 'trivial_resources::users::homedirs': }
  -> class { 'trivial_resources::users::sshdirs': }
  -> class { 'trivial_resources::users::sshcontrolfiles': }
  -> class { 'trivial_resources::users::premadesshkeys': }
  -> Class['trivial_resources::users']
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
