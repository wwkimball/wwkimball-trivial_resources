# Enables management of arbitrary file-system symbolic links.
#
# @param defaults Hash of Puppet attributes to apply to all managed symbolic
#  links that don't override these.
# @param resources Hash of the symbolic links to generate of form:
#  absolute_root_for_subordinate_links_1:
#    subordinate_link_name_1:
#      target: /absolute/path/to/remote/directory_1
#      ensure: present|absent
#      owner:  link-owner-if-different-from-$defaults::user
#      group:  link-group-if-different-from-$defaults::group
#      mode:   link-mode-if-different-from-$defaults::mode
#    subordinate_link_name_N:
#      target: /absolute/path/to/remote/directory_N
#      ...
#    ...
#  absolute_document_root_for_subordinate_links_N:
#    ...
#
class trivial_resources::symlinks(
  Hash[String, Any]  $defaults,
  Hash[
    Stdlib::Absolutepath,
    Hash[
      Pattern[/^[^\/]+$/],
      Struct[{
        target             => Stdlib::Absolutepath,
        Optional['ensure'] => Enum['present', 'absent'],
        Optional['owner']  => String[1],
        Optional['group']  => String[1],
        Optional['mode']   => String[1],
      }]
    ]
  ]                  $resources,
) {
  $resources.each | Stdlib::Absolutepath $linkroot, Hash $links | {
    $links.each | String $link, Hash $attrs | {
      $_attrs = delete_undef_values(merge(
        delete($attrs, ['ensure']),
        { ensure => $attrs['ensure'] ? {
            'absent' => absent,
            default  => link,
          },
        },
        $defaults,
      ))

      file { "${linkroot}/${link}":
        * => $_attrs,
      }
    }
  }
}
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
