# JBoss Modules application

class assist::modules (
    $version = lookup('versions::jboss_modules', 'prototype')
    # 48?
  )
{
  File { owner => $gsajboss6::user['name'], group => $gsajboss6::group['name'] }

  XXX 'appconfig' should be from modules/applications
  
  file { 'appconfig/jboss/modules' :
    ensure  => directory,
    path    => XXX
    depends on ?
  }

  file { 'module_zip':
    ensure             => directory,
    sourceselect       => all,
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
