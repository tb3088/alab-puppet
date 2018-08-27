# JBoss Modules application

class gsajboss6::modules (
    $version,
    String $destdir = "$dirs['home']['path']}/modules"
    #"${gsajboss6::dirs['home']['path']}/modules"
  )
{
  include gsajboss6

  # use JBOSS_HOME/modules as TLD for now.
  # TODO Not great because it 'contaminates' software distro and
  # also need multiple copies/links if multiple JBOSS_HOME installed.
  #  alternatively /usr/local/lib/$product.
  # and possible execution of 'module add'.
  # eg. module add --name=org.oracle --slot=main --resources=/PATH/TO/ojdbc6.jar --dependencies=javax.api,javax.transaction.api
  
  file { $destdir :
    ensure  => directory,
    #path    => XXX
    depends on ?
  }

  $method = 's3'
  $fetch_cmd = lookup("cloud::bucket_command.${method}")
  
  exec { 'fetch_java' :
  #FIXME --recursive doesn't work except on DIRs. otherwise need individual filename(s).
  #TODO using s3cmd is far more convenient than 'aws s3 cp'
    command     => "${fetch_cmd} --recursive ${source} .",
    provider    => shell,
    cwd         => $os::dirs['temp']['path'],
    refreshonly => true
  }

  file { 'jboss/module_zip':
    ensure  => directory,
    sourceselect => all,
    owner   => 'jboss',
    group   => 'jboss',
    source  => "/srv/filebucket/JBoss6Modules/${version}",
    recurse => true,
    ignore  => '.svn',
    source_permissions => ignore,
    purge   => true,
    backup  => false,
    force   => true,
    require => File['FIXME appconfig/jboss'],
  }~>
  exec { 'unzip-module_zip':
    command     => 'rm -rf *; tar xzf /opt/sw/jboss/appconfig/jboss/module_zip/jboss-modules-*-module-package.tgz',
    cwd         => '/opt/sw/jboss/appconfig/jboss/modules',
    path        => ['/bin','/usr/bin'],
    refreshonly => true,
    require     => [ File['/opt/sw/jboss/appconfig/jboss/modules'], File['/opt/sw/jboss/appconfig/jboss/module_zip'], ],
  }
}
