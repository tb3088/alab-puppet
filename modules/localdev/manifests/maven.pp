# Module to install set up for local development

class localdev::maven {
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
    command     => 'wget http://apache.osuosl.org/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz',
    cwd         => '/vagrant/installers',
    creates     => '/vagrant/installers/apache-maven-3.3.9-bin.tar.gz',
  }->
  exec {'untar-maven':
    command => 'tar xzf apache-maven-3.3.9-bin.tar.gz -C /usr/local',
    cwd     => '/vagrant/installers',
    creates => '/usr/local/apache-maven-3.3.9',
  }->
  exec {'link-maven':
    command => 'ln -s apache-maven-3.3.9 maven',
    cwd     => '/usr/local',
    creates => '/usr/local/maven',
  }

  file { '/etc/profile.d/maven.sh':
    ensure  => present,
    mode    => '0755',
    content => "export M2_HOME=/usr/local/maven\nexport PATH=\${M2_HOME}/bin:\${PATH}\n"
  }

}