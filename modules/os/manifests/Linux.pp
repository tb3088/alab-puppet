class os::linux inherits os::unix
{

# TODO these are RHEL, use case statements to branch
# TODO change to Hiera with deep merge?
# eg. 'ec2-user'=500 on AmzLinux


#  sudoers is differnt

  $distro_compat = lookup('os::distro_compat')

  # TODO leverage Hiera
  # File['system_shadow'] {
    # group => $facts['os']['family'] ? {
      # 'Debian' => 'shadow',
      # default  => undef
    # }
  # }

}

