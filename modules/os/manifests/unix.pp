class os::unix {

  # example:
  #   $perms['file'] - $umask
  #   $perms['file'] - $perms['group'] * $perms['write']
  #   $perms['file'] - ($perms['group'] + $perms['other']) * $perms['write']
  #
  # TODO define a macro to help with the math? eg. group_write(input) would emit input+group*write
  # so you could do user_read(group_read(group_write(0)), -1)?


  # Service { }
  #TODO change to Hiera
    # ensure/enabled are defined in specific class
#    hasstatus  => $::facts['os']['family'] ? {
#        /(Solaris|RedHat|Debian)/ => true,
#        # no 'default' -> compile error as desired
#    },
#    hasrestart => $::facts['os']['family'] ? {
#        /(Solaris|RedHat|Debian)/ => true,
#        # no 'default' -> compile error as desired
#    }
 
}
