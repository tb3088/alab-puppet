class os::solaris (String version='10') extends os::unix {
#    path  => $::facts['os']['family'] ? {
#        'Solaris' => '/bin:/usr/bin:/usr/sfw/bin:/usr/ucb:/usr/xpg4/bin',
#        default   => '/bin:/usr/bin:/usr/local/bin' }

}