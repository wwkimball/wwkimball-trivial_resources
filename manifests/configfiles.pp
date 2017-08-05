# Class: trivial_resources::configfiles
#
# This class provides a generic means of configuring arbitrary text-based
# configuration files.  In general, you do NOT want to use this mechanism
# because resources created by this code support only a limited set of Puppet
# meta fields.  Rather, use this ONLY for out-of-band files that must exist, but
# aren't otherwise tied to any other process, flow, or logic (like static
# end-user preference files).  Supported types include "Java-style Properties",
# "Shell Script Variables", "Windows-style INI", and XML.
#
# Parameters:  see init.pp
#
# Actions:
# - Creates or destroys the indicated configuration files
#
# Requires: see init.pp
#
# Sample Usage:
#   ---
#   classes:
#     - trivial_resources
#
#   trivial_resources::ini_files:
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
#   trivial_resources::property_files:
#     '/etc/myapp/app.properties':
#       config:
#         myKey1: Some Value
#         myKey2: Another Value
#     '/etc/otherapp/otherapp.conf':
#       config:
#         theirKey1: 5280
#         theirKey2: Some other value
#
#   trivial_resources::shell_files:
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
#   trivial_resources::xml_files:
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
class trivial_resources::configfiles {
  pick($trivial_resources::ini_files, {}).each |
    String $resource_name,
    Hash   $resource_props,
  | {
    ::trivial_resources::defines::ini_file {
      $resource_name: *=> $resource_props;
    }
  }

  pick($trivial_resources::property_files, {}).each |
    String $resource_name,
    Hash   $resource_props,
  | {
    ::trivial_resources::defines::property_file {
      $resource_name: *=> $resource_props;
    }
  }

  pick($trivial_resources::shell_files, {}).each |
    String $resource_name,
    Hash   $resource_props,
  | {
    ::trivial_resources::defines::shell_file {
      $resource_name: *=> $resource_props;
    }
  }

  pick($trivial_resources::xml_files, {}).each |
    String $resource_name,
    Hash   $resource_props,
  | {
    ::trivial_resources::defines::xml_file {
      $resource_name: *=> $resource_props;
    }
  }
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
