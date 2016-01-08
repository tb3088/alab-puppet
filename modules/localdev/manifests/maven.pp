# Module to install set up for local development

class localdev::maven
(
  $maven_version = $localdev::params::maven_version,
  $maven_filename = $localdev::params::maven_filename,
  $maven_dl_url = $localdev::params::maven_dl_url,	
) inherits localdev::params
{
  Exec {
    user  => 'root',
    group => 'root',
    path  => ['/bin','/usr/bin',],
  }

  # Local settings for Maven:
  file { '/opt/sw/jboss/.m2':
    ensure => directory,
    owner  => 'jboss',
    group  => 'jboss',
    mode   => '0770',
  }
  file { '/opt/sw/jboss/.m2/settings.xml':
    ensure => present,
    owner  => 'jboss',
    group  => 'jboss',
    mode   => '0640',
    source => 'puppet:///modules/localdev/settings.xml',
  }

  exec {'get-maven':
    command     => "wget ${maven_dl_url}",
    cwd         => '/vagrant/installers',
    creates     => "/vagrant/installers/${maven_filename}",
  }->
  exec {'untar-maven':
    command => "tar xzf ${maven_filename} -C /usr/local",
    cwd     => '/vagrant/installers',
    creates => "/usr/local/apache-maven-${maven_version}",
  }->
  exec {'link-maven':
    command => "ln -s apache-maven-${maven_version} maven",
    cwd     => '/usr/local',
    creates => '/usr/local/maven',
  }

  file { '/etc/profile.d/maven.sh':
    ensure  => present,
    mode    => '0755',
    content => "export M2_HOME=/usr/local/maven\nexport PATH=\${M2_HOME}/bin:\${PATH}\n"
  }

}