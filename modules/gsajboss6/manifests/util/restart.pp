define gsajboss6::util::restart ($ensure, $instance = $title) {
  if ($ensure == 'present') {
    exec { "start_${instance}":
      command     => '/bin/true',
      unless      => "/usr/bin/pgrep -f 'c ${instance}'",
      notify      => Exec["restart_${instance}"],
      logoutput   => true,
      refreshonly => true,
    }

    exec { "restart_${instance}":
      command     => "/opt/sw/jboss/rc_scripts/restart_jboss_${instance}.sh",
      refreshonly => true,
      logoutput   => on_failure,
      user        => 'jboss',
      group       => 'jboss',
    }
  }
}
