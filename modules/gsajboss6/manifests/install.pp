# TODO replace with https://github.com/biemond/biemond-wildfly ?
# also use https://github.com/dsestero/download_uncompress

class gsajboss6::install (
    Variant[String, Numeric] $version = 6.4,
    String $source  = $os::dirs['temp']['path'],
    Variant[String, Array[String]] $package,
    Variant[String, Array[Hash]] $file,
    Variant[String, Array[String] $destdir
  )
{
  #FIXME - riddled with multiple dangerous assumptions!
  
  include stdlib
  include os
  include gsajboss6
  
  #TODO support "any" version
  if version != 6.4 { fail("Unrecognized JBoss version: '${version}'") }
  
  #require machine_conf::repo
  #require machine_conf::hosts
  
  file {[
        '/opt',
        '/opt/sw',  #FIXME deprecate and fix GSA scripts
        $dirs['root']['path'],
    ] :
    *   => $os::default['directory'],
  }

  #TODO - regex match against $source
  $method = 's3'
  $fetch_cmd = lookup("cloud::bucket_command.${method}.get")

  #TODO filtering so as to not copy everything?
  exec { 'fetch_jboss' :
  #FIXME --recursive doesn't work except on DIRs. otherwise need individual filenames.
    command     => "${fetch_cmd} --recursive ${source} .",
    provider    => shell,
    cwd         => $os::dirs['temp']['path'],
    refreshonly => true
  }

  #TODO handle array of files
  #FIXME should depend on File[home.path]
if ! empty($file) {
  exec { $file :
    command     => "unzip ${os::dirs['temp']['path']}/${file}",
    provider    => shell,
    cwd         => $gsajboss6::dirs['root']['path'],
    umask       => $os::umask,
    creates     => $gsajboss6::dirs['home']['path'],
    # 'require' is not sufficient to trigger the Exec['fetch']
    notify      => Exec['fetch_jboss'],
  }
}

  #TODO frankly this belongs as a tar-ball or a relocatable RPM with junk removed,
  # and basepath=/usr/local/gsa since it includes scripts, XML and helper classes for several
  # JBOSS and Tomcat versions and closely related products.
if ! empty($package) {
  package { 'gsainstall' :
    ensure      => installed,
    provider    => rpm,     #TODO detect if repo is defined then use yum/apt per os.distro
    #TODO handle all $methods
    source      => "${getparam(Exec['fetch_jboss'], 'cwd')}/${package}${lookup('os::package.suffix')}",
    notify      => Exec['fetch_jboss'],
  }

  #TODO convert to template because it gets edited (by?)
  file { "${gsajboss6::dirs['conf']['path']}/servertab/servertab.props" :
    ensure      => present,
    mode        => '0640',
    #FIXME hacky! base path of the above RPM/TAR should be used. Define 'dirs['install']?
    source      => "${gsajboss6::dirs['root']['path']}/gsainstall/env/servertab.props",
    replace     => false,
    require     => Package['gsainstall']
  }

  #TODO supply re-written scripts or perhaps patches
    # file_line { 'fix-gsa-script-bug':
      # path    => '/opt/sw/jboss/gsaenv/bashrc.common.sh',
      # line    => '  local THIS_COMMAND="cd ${THIS_GSA_CONFIG_DIR}/server/instanceconfig/deployments" ;',
      # match   => '  local THIS_COMMAND="cd \${THIS_GSA_CONFIG_DIR}/server/instanceconfig/deployment" ;',
      # require => Package[$gsainstall],
    # }
}


  #FIXME change to ERB? Also uid=jboss' .bashrc should NOT be the place to manage
  # instances. call it 'env.sh' and put it in JBOSS_BASE/bin like is done with CATALINA.
    # This script will make sure we run the restart command with the environment in place.
    # The old solution of using 'su -' does not always work since it may require a tty.
  file { "${gsajboss6::dirs['root']['path']}/rc_scripts/restart_instance.sh" :
    ensure      => present,
    content     => "#!/bin/bash

source ${$gsajboss6::dirs['root']['path']}/.bashrc
${$gsajboss6::dirs['root']['path']}/rc_scripts/restart_jboss_\${1:?}.sh
",
    mode        => '0750',
    require     => Package['gsainstall']    # depends on .../rc_scripts/ which comes from the Package
  }

  contain gsajboss6::keystores
#pending  include gsajboss6::jboss_modules
  #include applications::jboss_modules
}
