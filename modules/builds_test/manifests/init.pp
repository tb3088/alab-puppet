# This module is purely to test 'builds' file server.

class builds_test {
  file { '/home/vagrant/important_file.txt':
    ensure => present,
    source => 'puppet:///builds/important_file.txt',
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => '0640',
  }
}