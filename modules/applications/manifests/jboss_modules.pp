# JBoss Modules application

class applications::jboss_modules (
  $version=$applications::params::jboss_modules_version
) inherits applications::params
{
  file {'/opt/sw/jboss/appconfig/jboss/modules':
    ensure => directory,
    owner  => 'jboss',
    group  => 'jboss',
  }
  file { '/opt/sw/jboss/appconfig/jboss/module_zip':
    ensure             => directory,
    sourceselect       => all,
    owner              => 'jboss',
    group              => 'jboss',
    source             => "/srv/filebucket/JBoss6Modules/${version}",
    recurse            => true,
    ignore             => '.svn',
    source_permissions => ignore,
    purge              => true,
    backup             => false,
    force              => true,
    require            => File['/opt/sw/jboss/appconfig/jboss'],
  }~>
  exec { 'unzip-jboss-module-files':
    command     => 'rm -rf *; tar xzf /opt/sw/jboss/appconfig/jboss/module_zip/jboss-modules-*-module-package.tgz',
    cwd         => '/opt/sw/jboss/appconfig/jboss/modules',
    path        => ['/bin','/usr/bin'],
    refreshonly => true,
    require     => [ File['/opt/sw/jboss/appconfig/jboss/modules'], File['/opt/sw/jboss/appconfig/jboss/module_zip'], ],
    user        => 'jboss',
    group       => 'jboss',
  }
}
