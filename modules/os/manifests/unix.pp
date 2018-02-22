class os::unix {

  $perms = {
    'dir'   => 777,
    'file'  => 666,
    'suid'  => 4000,
    'sgid'  => 2000,
    'sticky'=> 1000,
    't'     => 1000,
    'exec'  => 1,
    'e'     => 1,
    'write' => 2,
    'w'     => 2,
    'read'  => 4,
    'r'     => 4,
    'user'  => 100,
    'u'     => 100,
    'group' => 10,
    'g'     => 10,
    'other' => 1,
    'o'     => 1,
    'all'   => 111
  }
  # example:
  #   $perms['file'] - $umask
  #   $perms['file'] - $perms['group'] * $perms['write']
  #   $perms['file'] - ($perms['group'] + $perms['other']) * $perms['write']
  #
  # TODO define a macro to help with the math? eg. group_write(input) would emit input+group*write
  # so you could do user_read(group_read(group_write(0)), -1)?

  $umask = 22

# TODO these are from redhat, slim down and add to os::linux
  $uid = {
    'root'  => 0,
    0       => 'root',
    'bin'   => 1,
    'daemon' => 2,
    'adm'   => 3,
    'lp'    => 4,
    'sync'  => 5,
    'shutdown' => 6,
    'halt'  => 7,
    'mail'  => 8,
    'uucp'  => 10,
    'nobody' => 99
  }
  $users = {
  }
  
  $gid = {
    'root'  => 0,
    0       => 'root',
    'bin'   => 1,    #:bin,daemon
    'daemon' => 2,   #:bin,daemon
    'sys'   => 3,    #:bin,adm
    'adm'   => 4,    #:adm,daemon
    'tty'   => 5,
    'disk'  => 6,
    'lp'    => 7,    #:daemon
    'mem'   => 8,
    'kmem'  => 9,
    'wheel' => 10,
    'nobody' => 99,
    'users' => 100
  }

  $groups = {
    'bin'   => ['bin', 'daemon'],
  }

  # "${name}::${osflavor}::owner".getvar,
  
  File {
    owner   => $uid[0],
    group   => $gid[0],
    mode    => os::mode($perms['file'] - $umask)
  }

  Os::Directory {
    owner => $uid[0],
    group => $gid[0],
    mode  => os::mode($perms['dir'] - $umask)
  }

  Exec { path => '/sbin:/bin:/usr/sbin:/usr/bin' }

  Service { }
    # ensure/enabled are defined in specific class
#    hasstatus  => $::facts['os']['family'] ? {
#        /(Solaris|RedHat|Debian)/ => true,
#        # no 'default' -> compile error as desired
#    },
#    hasrestart => $::facts['os']['family'] ? {
#        /(Solaris|RedHat|Debian)/ => true,
#        # no 'default' -> compile error as desired
#    }

  Package { }
    # force intelligent handlers, except these are compiled-in defaults!
#    provider => $::facts['os']['family'] ? {
#        'RedHat'  => 'yum',
#        'Debian'  => 'apt',
#        default   => unset
#    }

#----- Dirs -----

#  file { 'sysdir_etc' :
#    ensure => directory,
#    mode   => $mode['dir']
  os::directory { 'sysdir_etc' :
    path   => '/etc',
  }

  #TODO enforce mount point
#  file { 'sysdir_temp' :
#    ensure => directory,
  os::directory { 'sysdir_temp' :
    path   => '/tmp',
    mode   => os::mode($perms['dir'] + $perms['sticky'])
  }

  #TODO enforce mount point
#  file { 'sysdir_var' :
#    ensure => directory,
#    mode   => $mode['dir']
  os::directory { 'sysdir_var' :
      path   => '/var',
  }

#  file { 'sysdir_state' :
#    ensure => directory,
#    require => File['sysdir_var'],
#    path   => "${File['sysdir_var']['path']}/lib",
#    mode   => $mode['dir']
  os::directory { 'sysdir_state' :
    require => Os::Directory['sysdir_var'],
    path   => "${Os::Directory['sysdir_var']['path']}/lib",
  }

#  file { 'sysdir_log' :
#    ensure => directory,
#    require => File['sysdir_var'],
#    path   => "${File['sysdir_var']['path']}/log",
#    mode   => $mode['dir']
#  }
#
#  file { 'sysdir_pid' :
#    ensure => directory,
#    require => File['sysdir_var'],
#    path   => "${File['sysdir_var']['path']}/run",
#    mode   => $mode['dir']
#  }
#
#  file { 'sysdir_cache' :
#    ensure => directory,
#    require => File['sysdir_var'],
#    path   => "${File['sysdir_var']['path']}/cache",
#    mode   => $mode['dir']
#  }
#
#  file { 'sysdir_lock' :
#    ensure => directory,
#    require => File['sysdir_var'],
#    path   => "${File['sysdir_var']['path']}/lock",
#    mode   => $mode['dir']
#  }
#
#  file { 'sysdir_spool' :
#    ensure => directory,
#    require => File['sysdir_var'],
#    path   => "${File['sysdir_var']['path']}/spool",
#    mode   => $mode['dir']
#  }
#
#  file { 'sysdir_mail' :
#    ensure => directory,
#    require => File['sysdir_var'],
#    path   => "${File['sysdir_spool']['path']}/mail",
#    mode   => $mode['dir']
#  }


#----- Files -----

  file { 'system_passwd' :
    require => Os::Directory['sysdir_etc'],
    path    =>  "${Os::Directory['sysdir_etc']['path']}/passwd",
#    require => File['sysdir_etc'],
#    path   =>  "${File['sysdir_etc']['path']}/passwd"
    mode    => os::mode(644)
  }

  file { 'system_shadow' :
#    require => File['sysdir_etc'],
#    path =>  "${File['sysdir_etc']['path']}/shadow", # solaris uses passwd.shadow?
    require => Os::Directory['sysdir_etc'],
    path =>  "${Os::Directory['sysdir_etc']['path']}/shadow",
    mode   => os::mode(640)
  }
#
#  file { 'system_group' :
#    require => File['sysdir_etc'],
#    path =>  "${File['sysdir_etc']['path']}/group"
#  }
 
}
