class os {
  
  $kernel = $facts['kernel'].downcase()
  class { "${name}::${kernel}" : }

  $separator = empty($facts['separator']) ? { 
        true    => {
            'file' => getvar("${name}::${kernel}::file_separator"),
            'path' => getvar("${name}::${kernel}::path_separator")
        },
        default => $facts['separator']
  }

# use inheritance instead?
  $perms = getvar("${name}::${kernel}::perms")

  define directory ( 
      String $path  = $title,
      String $owner = undef,
      String $group = undef,
      String $mode  = undef,
    ) {

 # File<| title == $title |>

  # $params = {
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
    $elements = os::dirs($path)
#   $elements.each | String $element| {
#   file { $element :
    file { $title :
      ensure => 'directory',
      path  => $path,
      owner => $owner,
      group => $group,
      mode  => $mode,
    }
#    }
  }

}
