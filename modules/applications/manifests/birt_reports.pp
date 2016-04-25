# CPRM application

class applications::birt_reports (
  $birt_reports_version = hiera('versions::birt_reports', 'baseline'),
  $birt_dir = '/opt/sw/jboss/birt',
  $birt_zip_dir = '/opt/sw/jboss/birt_zip',
)
{

  # Make sure the instance is present:
  applications::util::app_init { 'birt_reports': }

  # Deploy using Hiera info to get correct locations:
  # BIRT is special... needs different deployment than this.
  # gsajboss6::util::deploy { 'birt_reports': }

  ## Place application customizations here.

  $apps = hiera_hash('applications')
  $app = $apps['birt_reports']

  $builds_dir = $app['build_dirs'][0]
  $zip_name_pattern = $app['delete_patterns'][0]

  $hipchat_notify = hiera('hipchat::notify', false)

  file { $birt_dir:
    ensure => directory,
    owner  => 'jboss',
    group  => 'jboss',
  }
  file { $birt_zip_dir:
    ensure             => directory,
    sourceselect       => all,
    owner              => 'jboss',
    group              => 'jboss',
    source             => "puppet:///builds/${builds_dir}/${birt_reports_version}",
    recurse            => true,
    ignore             => '.svn',
    source_permissions => ignore,
    purge              => true,
    backup             => false,
    force              => true,
  }~>
  exec { 'unzip-birt-report-files':
    command     => "rm -rf *; unzip ${birt_zip_dir}/${zip_name_pattern}",
    cwd         => $birt_dir,
    path        => ['/bin','/usr/bin'],
    refreshonly => true,
    require     => [ File[$birt_dir], File[$birt_zip_dir], ],
    user        => 'jboss',
    group       => 'jboss',
  }
}
