# Module to configure nginx for local development.

class devproxy::svn_proxy {

  include devproxy::app_proxy

  File {
    owner  => root,
    group  => root,
    mode   => '0600',
  }

  host { 'svnedge.techflow.com':
    ip => '127.0.0.1',
  }

  # Command line SVN doesn't like SVN Edge, so proxy it:
  nginx::resource::upstream { 'svnedge':
    members => [ '10.10.1.105:443', ],
  }

  nginx::resource::vhost { 'svnedge.techflow.com':
    proxy         => 'https://svnedge',
    ssl           => true,
    listen_port   => '443',
    ssl_port      => '443',
    ssl_key       => '/etc/nginx/ssl/nginx-private.key.insecure',
    ssl_cert      => '/etc/nginx/ssl/gsarba.com.crt',
    ssl_protocols => 'TLSv1 TLSv1.1 TLSv1.2',
    ssl_ciphers   => 'EECDH+AESGCM:EDH+AESGCM:ECDHE-RSA-AES128-GCM-SHA256:AES256+EECDH:DHE-RSA-AES128-GCM-SHA256:AES256+EDH:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4',
  }


}