class os::linux
  (
    $family  = $facts['os']['family'],
    $distro  = $facts['os']['name'],
    $major   = $facts['os']['release']['major'],
    $minor   = $facts['os']['release']['minor']
  ) inherits os::unix
{

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

  $distro_compat = $facts['os']['name'] ? {
    # NOTE - assumes AWS using RHEL6 derivative
    'Amazon'          => 6,
    '/Debian|Ubuntu/' => $facts['distro']['codename'],
    default           => $facts['os']['release']['major'],
  }

  Exec { path   => '/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin' }
  #"${name}::${osflavor}::path".getvar }

  File['system_shadow'] {
    group => $facts['os']['family'] ? {
      'Debian' => 'shadow',
      default  => undef
    }
  }

}

