# JBoss Modules application

class applications::jboss_modules (
  $version=$applications::params::jboss_modules_version
) inherits applications::params
{
  file {'/appconfig/jboss/modules':
    ensure => directory,
    owner  => 'jboss',
    group  => 'jboss',
  }
  file { '/appconfig/jboss/module_zip':
    ensure             => directory,
    sourceselect       => all,
    owner              => 'jboss',
    group              => 'jboss',
    source             => "puppet:///builds/JBoss6Modules/${version}",
    recurse            => true,
    ignore             => '.svn',
    source_permissions => ignore,
    purge              => true,
    backup             => false,
    force              => true,
    require            => File['/appconfig/jboss'],
  }~>
  exec { 'unzip-jboss-module-files':
    command     => 'rm -rf *; tar xzf /appconfig/jboss/module_zip/jboss-modules-*-module-package.tgz',
    cwd         => '/appconfig/jboss/modules',
    path        => ['/bin','/usr/bin'],
    refreshonly => true,
    require     => [ File['/appconfig/jboss/modules'], File['/appconfig/jboss/module_zip'], ],
    user        => 'jboss',
    group       => 'jboss',
  }
}
