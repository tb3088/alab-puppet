# Module to install set up for local development

class machine_conf{
  require stdlib

  class { 'timezone':
    timezone => 'America/New_York',
  }

}
