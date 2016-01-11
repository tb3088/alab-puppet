# Module to configure nginx for local development.

class devproxy {

  class {'nginx':}
  
  include devproxy::app_proxy
  include devproxy::local_static
  include devproxy::svn_proxy

}