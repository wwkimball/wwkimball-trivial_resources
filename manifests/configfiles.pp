# Class: tlg_base::configfiles
#
# This class provides a generic means of configuring arbitrary text-based
# configuration files.  In general, you do NOT want to use this mechanism
# because resources created by this code support only a limited set of Puppet
# meta fields.  Rather, use this ONLY for out-of-band files that must exist, but
# aren't otherwise tied to any other process, flow, or logic (like static
# end-user preference files).  Supported types include "Java-style Properties",
# "Shell Script Variables", "Windows-style INI", and XML.
#
# Parameters:
# - iniFiles: Hash with repeating* structure:
#   FILE_PATH*:
#     ensure: absent|present
#     owner: File owner's name or ID
#     group: File owner's group or GID
#     config:
#       SECTION_NAME*:
#         KEY_NAME*: VALUE
# - propertyFiles
#   FILE_PATH*:
#     ensure: absent|present
#     owner: File owner's name or ID
#     group: File owner's group or GID
#     config:
#       KEY_NAME*: VALUE
# - shellFiles
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
# - xmlFiles
#   FILE_PATH:
#     ensure: absent|present
#     owner: File owner's name or ID
#     group: File owner's group or GID
#     config:
#       ROOT_CONTAINER_NAME:
#         XML_SERIALIZED_AS_YAML
#
# Actions:
# - Creates or destroys the indicated configuration files
#
# Requires: see metadata.json
#
# Sample Usage:
# This class is called and configured via Hiera.  Minimalist Hiera-YAML example:
#   ---
#   classes:
#     - tlg_base
#
#   tlg_base::configfiles::iniFiles:
#     '/etc/myapp/app.ini':
#       config:
#         section_name:
#           myKey1: Some Value
#           myKey2: Another Value
#     '/etc/otherapp/otherapp.ini':
#       config:
#         first_section:
#           theirKey1: 5280
#         second_section:
#           theirKey2: Some other value
#           theirArray:
#             - Value 1
#             - Value 2
#             - Value N
#
#   tlg_base::configfiles::propertyFiles:
#     '/etc/myapp/app.properties':
#       config:
#         myKey1: Some Value
#         myKey2: Another Value
#     '/etc/otherapp/otherapp.conf':
#       config:
#         theirKey1: 5280
#         theirKey2: Some other value
#
#   tlg_base::configfiles::shellFiles:
#     '/etc/tomcat7.d/myApp.sh':
#       config:
#         MY_KEY: Any long text value
#         MY_NUMBER_KEY: 1024
#         export:
#           EXPORT_THIS_KEY: Scalar value you need exported to subprocesses
#           EXPORT_KEY_N: More...
#         prepend:
#           CONCAT_THIS_KEY: Value that must be prefixed to same-named variables
#           CONCAT_KEY_N: More...
#         append:
#           CONCAT_THAT_KEY: Value to append to the end of same-named variables
#           CONCAT_KEY_N: More...
#         exportprepend:
#           EXPORT_PRE_CAT: Exports a prepended value
#           EXPORTED_CONCAT_KEY_N: More...
#         exportappend:
#           EXPORT_POST_CAT: Exports an appended value
#           EXPORTED_CONCAT_KEY_N: More...
#
#   tlg_base::configfiles::xmlFiles:
#     '/etc/anotherapp/config.xml':
#       config:
#         settings:
#           network:
#             port:
#               attribute.auto-increment: true
#               attribute.port-count: 100
#               value.text: 65432
#             ssl:
#               attribute.enabled: false
#           worker:
#             - attribute.name: priority
#               memory: 128
#               priority: 1
#             - attribute.name: default
#               memory: 256
#               priority: 5
#             - attribute.name: bulk
#               memory: 512
#               priority: 10
#
class tlg_base::configfiles {
  define ini_file(
    $ensure = present,
    $owner  = 'root',
    $group  = 'root',
    $config = undef,
  ) {
    file { $name:
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      content => template('tlg_base/iniFile.erb'),
    }
  }

  define property_file(
    $ensure = present,
    $owner  = 'root',
    $group  = 'root',
    $config = undef,
  ) {
    file { $name:
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      content => template('tlg_base/propertyFile.erb'),
    }
  }

  define shell_file(
    $ensure = present,
    $owner  = 'root',
    $group  = 'root',
    $config = undef,
  ) {
    file { $name:
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      content => template('tlg_base/shellFile.erb'),
    }
  }

  define xml_file(
    $ensure = present,
    $owner  = 'root',
    $group  = 'root',
    $config = undef,
  ) {
    file { $name:
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      content => template('tlg_base/xmlFile.erb'),
    }
  }

  # Attempt to merge all specified repo hash values across the configuration
  # hierarchy.  This is not using the automatic parameter lookup pattern due to:
  # https://tickets.puppetlabs.com/browse/HI-118
  # http://grokbase.com/t/gg/puppet-users/13ayxyyxmz/merge-behavior-deeper-and-hiera-hash
  # https://docs.puppetlabs.com/hiera/1/lookup_types.html#priority-default
  $iniFiles = hiera_hash('tlg_base::configfiles::iniFiles', {})
  $propertyFiles = hiera_hash('tlg_base::configfiles::propertyFiles', {})
  $shellFiles = hiera_hash('tlg_base::configfiles::shellFiles', {})
  $xmlFiles = hiera_hash('tlg_base::configfiles::xmlFiles', {})

  # Pass all the config data to the respective defines
  create_resources('tlg_base::configfiles::ini_file', $iniFiles)
  create_resources('tlg_base::configfiles::property_file', $propertyFiles)
  create_resources('tlg_base::configfiles::shell_file', $shellFiles)
  create_resources('tlg_base::configfiles::xml_file', $xmlFiles)
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
