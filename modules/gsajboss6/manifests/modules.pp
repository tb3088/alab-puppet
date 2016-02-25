# Install Techflow JBoss modules.

class gsajboss6::modules
(
  $jboss_modules_version = hiera('versions::jboss_modules', 'baseline'),
)
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
    source             => "puppet:///builds/JBoss6Modules/${jboss_modules_version}",
    recurse            => true,
    ignore             => '.svn',
    source_permissions => ignore,
    purge              => true,
    force              => true,
    require            => File['/appconfig/jboss'],
  }~>
  exec { 'unzip-report-files':
    command     => 'rm -rf *; tar xzf /appconfig/jboss/module_zip/jboss-modules-*-module-package.tgz',
    cwd         => '/appconfig/jboss/modules',
    path        => ['/bin','/usr/bin'],
    refreshonly => true,
    require     => [ File['/appconfig/jboss/modules'], File['/appconfig/jboss/module_zip'], ],
    user        => 'jboss',
    group       => 'jboss',
  }
}
