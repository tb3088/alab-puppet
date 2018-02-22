#
# Serves as the common class that will create a user and a set of directories passed
# as a parameter


define common::hombre(
    $username,
    $user_dirs = [],
    $mode = '0750',
){


	  user { $username :
	         ensure => 'present',
	         home => "/home/${username}",
	         managehome => true,
	         shell => '/bin/bash',
	  }

#TODO replace array with each().
#  $user_dirs.each() | $item | {
#    file { $item:
	  file { $user_dirs:
	    ensure => 'directory',
	    owner  => "${username}",
	    group  => "${username}",
	    mode   => $mode,
	    require => User[ $username ],
	  }

}
