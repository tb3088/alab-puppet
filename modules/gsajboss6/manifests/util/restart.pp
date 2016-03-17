define gsajboss6::util::restart ($ensure, $instance = $title) {
  include stdlib

  if ($ensure == 'present') {
    exec { "start_${instance}":
      command     => '/bin/true',
      unless      => "/usr/bin/pgrep -f 'c ${instance}'",
      notify      => Exec["restart_${instance}"],
      logoutput   => true,
      refreshonly => true,
    }


    $hipchat_notify = hiera('hipchat::notify', false)

    if $hipchat_notify {
      $hipchat_room = uriescape(hiera('hipchat::room', 'JBoss 6 Upgrade'))
      $hipchat_apikey = hiera('hipchat::apikey', '88068e6d406ca3a8eea31c92c35da7')
      exec { "hc_notify_restart_${instance}":
        command     => "/usr/bin/curl -x https://squid:3128 -output /dev/null -d \"room_id=${hipchat_room}&from=Puppet&message=Restarting+instance+${instance}&color=green&notify=1\" \"https://api.hipchat.com/v1/rooms/message?format=json&auth_token=${hipchat_apikey}\"",
        refreshonly => true,
        before      => Exec["restart_${instance}"],
      }

    }

    exec { "restart_${instance}":
      command     => "/bin/su - jboss --command='/opt/sw/jboss/rc_scripts/restart_jboss_${instance}.sh'",
      refreshonly => true,
      logoutput   => on_failure,
    }
  }
}
