# Class: trivial_resources
#
# This module manages resources that are too trivial to warrant their own
# full-fledged Puppet modules.
#
# Parameters:
# - ini_files: Hash with repeating* structure:
#   FILE_PATH*:
#     ensure: absent|present
#     owner: File owner's name or ID
#     group: File owner's group or GID
#     config:
#       SECTION_NAME*:
#         KEY_NAME*: VALUE
# - property_files:
#   FILE_PATH*:
#     ensure: absent|present
#     owner: File owner's name or ID
#     group: File owner's group or GID
#     config:
#       KEY_NAME*: VALUE
# - shell_files:
#   FILE_PATH*:
#     ensure: absent|present
#     owner: File owner's name or ID
#     group: File owner's group or GID
#     config:
#       KEY_NAME*: VALUE
#       export:
#         EXPORT_KEY*: Scalar value you need exported to subprocesses
#       prepend:
#         CONCAT_KEY*: Value that must be prefixed to same-named variables
#       append:
#         CONCAT_KEY*: Value to append to the end of same-named variables
#       exportprepend:
#         EXPORT_CAT*: Exports a prepended value
#       exportappend:
#         EXPORT_CAT*: Exports an appended value
# - xml_files:
#   FILE_PATH:
#     ensure: absent|present
#     owner: File owner's name or ID
#     group: File owner's group or GID
#     config:
#       ROOT_CONTAINER_NAME:
#         XML_SERIALIZED_AS_YAML
# - tidy_rules:  A hash of rule definitions based on
#   https://docs.puppetlabs.com/puppet/latest/reference/type.html#tidy
#   excluding all resource dependency attributes (before/after/require/notify).
#
# Actions: see each subclass of this module
#
# Requires: see metadata.json
#
# Sample Usage:
# ---
# classes:
#   - trivial_resources
#
class trivial_resources(
  Hash[String, Any]            $package_defaults,
  Hash[String, Any]            $tidy_rule_defaults,
  Optional[Hash[String, Hash]] $ini_files      = undef,
  Optional[Hash[String, Hash]] $packages       = undef,
  Optional[Hash[String, Hash]] $property_files = undef,
  Optional[Hash[String, Hash]] $shell_files    = undef,
  Optional[Hash[String, Hash]] $tidy_rules     = undef,
  Optional[Hash[String, Hash]] $xml_files      = undef,
) {
  class { 'trivial_resources::packages': }
  -> class { 'trivial_resources::configfiles': }
  -> class { 'trivial_resources::tidies': }
  -> Class['trivial_resources']
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
