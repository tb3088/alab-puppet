# Restart server after changes are made.
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

    # Decide if we should use Hiera or not:
    $hipchat_notify = hiera('hipchat::notify', false)

    if $hipchat_notify {
      # If using Hiera, get the key and room:
      $hipchat_room = uriescape(hiera('hipchat::room', 'JBoss 6 Upgrade'))
      $hipchat_apikey = hiera('hipchat::apikey', '88068e6d406ca3a8eea31c92c35da7')
      exec { "hc_notify_restart_${instance}":
        command     => "/usr/bin/curl -x https://squid:3128 -output /dev/null -d \"room_id=${hipchat_room}&from=Puppet&message=Restarting+${instance}+instance&color=green&notify=1\" \"https://api.hipchat.com/v1/rooms/message?format=json&auth_token=${hipchat_apikey}\"",
        refreshonly => true,
        before      => Exec["restart_${instance}"],
      }

    }

    # Restart the instance:
    exec { "restart_${instance}":
      command     => "/opt/sw/jboss/rc_scripts/restart_instance.sh ${instance}",
      refreshonly => true,
      logoutput   => on_failure,
      user        => 'jboss',
      group       => 'jboss',
      require     => File['/opt/sw/jboss/rc_scripts/restart_instance.sh'],
    }
  }
}
