# This class provides generic data-driven control over user accounts.
#
# @example
#   ---
#   classes:
#     - trivial_resources
#
#   trivial_resources::normal_users:
#     gwashington:
#       groups:
#         - presidents
#       password:  ENC[PKCS7,AAAhexstringA==]   # EYAML-encoded, pre-encrypted value
#       ssh_authorized_keys:
#         gWashingtonPublicKey:
#           key:  AAmorehexA==
#           type: rsa2
#     jdoe:
#       groups:
#         - people
#       password:  ENC[PKCS7,AABhexstringC==]   # EYAML-encoded, pre-encrypted value
#       ssh_generated_keys:
#         id_rsa:
#           type: rsa2
#           bits: 4096
#
class trivial_resources::users(
  Optional[Hash[String, Hash]] $normal_users = undef,
  Optional[Hash[String, Hash]] $system_users = undef,
) {
  # Sequence the subclasses
  class { '::trivial_resources::users::homes': }
  -> class { '::trivial_resources::users::groups': }
  -> class { '::trivial_resources::users::accounts': }
  -> class { '::trivial_resources::users::sshdirs': }
  -> class { '::trivial_resources::users::sshcontrolfiles': }
  -> class { '::trivial_resources::users::premadesshkeys': }
  -> Class['trivial_resources::users']
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
