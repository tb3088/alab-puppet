class os::freebsd {
    family  = $facts['os']['family'],
    distro  = $facts['os']['name'],
    major   = $facts['os']['release']['major'],
    minor   = $facts['os']['release']['minor']
  ) inherits os::unix {

  $gid = $os::unix::gid + {
    'wheel' => 0,   #FIXME, true?
    'mail'  => 12,
    'uucp'  => 14,
    'man'   => 15,
    'utmp'  => 22,
    'lock'  => 54,
    'sshd'  => 74,
    'dbus'  => 81,
    'nfsnobody' => 65534
  }

#    path  => $::facts['os']['family'] ? {
#        'Solaris' => '/bin:/usr/bin:/usr/sfw/bin:/usr/ucb:/usr/xpg4/bin',
#        default   => '/bin:/usr/bin:/usr/local/bin' }

  #TODO passwords, uid, groups
#FIXME use 'system_passwd' reference  
  # File['/etc/passwd'] {
    # group   => 'wheel'
  # }

  # File['/etc/passwd'] {
    # group   => 'wheel'
  # }

}
