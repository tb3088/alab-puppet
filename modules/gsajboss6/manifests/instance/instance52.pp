# Create JBoss instance

define gsajboss6::instance::instance52($base_port,$jboss_version,$base_instance='default')
{
  require gsajboss6::packages
  include stdlib

  exec{ "create-instance-${title}":
    command     => "echo 'y' | /opt/sw/jboss/gsainstall/${jboss_version}/bin/install_server.sh ${name} ${base_port} ${base_instance}",
    path        => ['/bin','/usr/bin'],
    environment => ['HOME=/opt/sw/jboss'],
    cwd         => "/opt/sw/jboss/gsainstall/${jboss_version}/bin/",
    creates     => "/opt/sw/jboss/gsaconfig/instances/${name}/",
    user        => jboss,
    group       => jboss,
  }->
  file_line { "instance-alias-${title}":
    path  => '/opt/sw/jboss/gsaconfig/servertab/servertab.props',
    line  => "gsa.instance.alias.${name}=${name}",
    match => "^gsa.instance.alias.${name}=.*$",
  }->
  file_line { "instance-rcstart-${title}":
    path  => '/opt/sw/jboss/gsaconfig/servertab/servertab.props',
    line  => "gsa.instance.rcstart.${name}=ON",
    match => "^gsa.instance.rcstart.${name}=.*$",
  }->
  # Using a File resource will interfere with the instance configuration module
  exec { "make-${name}-instance-dirs":
    command => "mkdir -p /opt/sw/jboss/gsaconfig/instances/${name}/server/instanceconfig/{conf,deploy,deployers,lib}",
    path    => ['/bin','/usr/bin'],
    creates => "/opt/sw/jboss/gsaconfig/instances/${name}/server/instanceconfig/deploy",
    user    => jboss,
    group   => jboss,
  }
}
