class os (
    Hash    $default,
    Hash    $separator = $facts['separator'],
    Hash    $perms,
    Variant[String, Integer]
            $umask = $facts['umask'],
    Variant[String, Array[String]]
            $path = $facts['path'],
    Hash    $users,
    Hash    $groups,
    Hash    $uids,
    Hash    $gids,
    Variant[String, Integer]
            $distro_compat,
    Hash    $dirs,
    Hash    $files,
  )
{
  include stdlib

  Exec { path => $path }    # 'path' handles both String or Array[String]
  File { * => $os::default['file'] }

  #TODO
  # get os::dirs() working! returns sorted list of all parent paths and dups removed
  #
  #puppet v3 way
  #create_resources(File, os::dirs(various_dirs), { ensure => directory, some_more_defaults})

  # puppet v4 way - https://www.devco.net/archives/2015/12/16/iterating-in-puppet.php
  #each($os::dirs([list of dirs]) |$name| {
  # file { $name:
  #     * => $attributes + $default['directory']
  # }
  #}

  # handle different data types, especially Array as input
  define directory (
      Variant[String, Array[String]] $path = $title,
      Hash $attributes = $default['directory']
    )
  {
    # frankly should just make this an Exec of 'install -d -o $owner -g $group -m $mode $path'.
    # on windows use 'mkdir' but doesn't address ownership

    # File<| title == $title |>
  #   $params = {
    # ensure => present,
    # owner  => 'root',
    # group  => 'root',
    # mode   => $mode,
  # };

  # if !defined(File[$title]) and file_exists($title) {
    # file { $title:
      # * => $params,
    # }
  # } else {
    # File<| title == $title |> {
      # * => $params,
    # }
  # }
    #TODO
#   $elements = split path to result in array with successive dirname()
#    $elements = os::dirs($path)
#   $elements.each | String $element| {
#   file { $element :
    file { $title :
      ensure => 'directory',
      *     => $os::default['directory']
    }
  }

  class { "${name}::${facts['kernel'].downcase()}" : }
}
