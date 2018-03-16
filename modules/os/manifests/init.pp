class os (
    Hash $separator = $facts['separator'],
    Hash $perms = undef,
    Variant[String, Integer] $umask = empty($facts['umask']) ? {
        true    => 22,
        default => $facts['umask']
    },
    Array[String] $path,
  )
{
  include stdlib

  # $users = lookup('os::users' with deep merge)
  # $groups = lookup('os::groups' with deep merge)
  # $uid = lookup('os::uid' with deep merge)
  # $gid = lookup('os::gid' with deep merge)
  
  Exec { path => join(lookup('os::path'), $separator['file']) }

  File { * => lookup('os::default.file') }

  #TODO 
  # get dirs() working
  # handle different data types, especially Array as input
  define directory ( 
      Variant[String, Array[String]] $path  = $title,
      Hash $attributes = lookup('os::default.directory', Hash, { 
            default_value => { user => 0, group => 0, mode => '0755' }
        }),
    )
  {
    # frankly should just make this an Exec of 'install -d -o $owner -g $group -m $mode $path'.
    # on windows 'mkdir' but doesn't address ownership

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
      *       => lookup('os::default.directory')
    }
  }

  #$kernel = $facts['kernel'].downcase()
  class { "${name}::${facts['kernel'].downcase()}" : }
}
