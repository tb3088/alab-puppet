class os::linux inherits os::unix
{

# TODO these are RHEL, use case statements to branch
# eg. 'ec2-user'=500 on AmzLinux
#  sudoers is differnt

  # TODO implement in Hiera
  # File['system_shadow'] {
    # group => $facts['os']['family'] ? {
      # 'Debian' => 'shadow',
      # default  => undef
    # }
  # }

}

