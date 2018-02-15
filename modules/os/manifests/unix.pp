
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
    'o'     => 1
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
  }

  file {'/etc/passwd':
    ensure  => 'present'
    #owner
    mode    => "${perms['file'] - umask}"
  }
  
  file {'/etc/shadow':
    ensure  => 'present',
    #type of file
    #owner
    #mode
  }
}
