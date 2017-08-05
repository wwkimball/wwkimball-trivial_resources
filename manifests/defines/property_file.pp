define trivial_resources::defines::property_file(
  Enum['present', 'absent'] $ensure = present,
  String                    $owner  = 'root',
  String                    $group  = 'root',
  String                    $mode   = '0664',
  Hash                      $config = undef,
) {
  file { $name:
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => template("${module_name}/property_file.erb"),
  }
}
