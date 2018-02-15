class os::linux (
    family  = $facts['os']['family'],
    distro  = $facts['os']['name'],
    major   = $facts['os']['release']['major'],
    minor   = $facts['os']['release']['minor']
  ) inherits os::unix {

# TODO these are RHEL, use case statements to branch
# eg. 'ec2-user'=500 on AmzLinux
  $gid = $gid + {
    'mail'  => 12,
    'uucp'  => 14,
    'man'   => 15,
    'utmp'  => 22,
    'lock'  => 54,
    'sshd'  => 74,
    'dbus'  => 81,
    'nfsnobody' => 65534
  }

#  sudoers is differnt

  File['/etc/passwd'] {
    group   => 'root'
  }

  File['/etc/passwd'] {
    group   => 'root'
  }
}

