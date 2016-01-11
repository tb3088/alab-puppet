# Module to configure nginx for local development.

class devproxy::local_static {

  include devproxy::app_proxy

  File {
    owner  => root,
    group  => root,
    mode   => '0600',
  }

  host { 'nowhere':
    ip           => '127.0.0.1',
    host_aliases => ['nowhere.techflow.com','www.nowhere.techflow.com'],
  }

  file { '/var/www':
    ensure => directory,
    mode   => '0755',
  }
  
  file { '/var/www/nowhere.techflow.com':
    source  => 'puppet:///modules/devproxy/site',
    recurse => true,
    purge   => true,
    owner   => 'nginx',
    group   => 'nginx',
  }

  # Hijack the default start page:
  file { '/usr/share/doc/HTML/index.html':
    source => 'puppet:///modules/devproxy/redirect.html',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  nginx::resource::vhost { 'nowhere.techflow.com':
    www_root    => '/var/www/nowhere.techflow.com/',
    ssl         => false,
    listen_port => '80',
  }

  # To permit easy addition of the CA cert:
  nginx::resource::location { '/devsetup':
    location_alias => '/var/www/nowhere.techflow.com/',
    vhost          => '*.gsarba.com',
    ssl            => true,
    ssl_only       => true,
  }

}