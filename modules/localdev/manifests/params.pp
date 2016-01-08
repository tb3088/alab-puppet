# Parameters for setting up local dev environment

class localdev::params {
  $proxy_name        = hiera('jboss::proxy_name', 'lab5-portal.fas.gsarba.com')
  $extra_packages    = hiera_array('yum::packages')

  $java_version      = hiera('downloads::java::version','8u65')
  $java_full_version = hiera('downloads::java::full_version','1.8.0_65')
  $java_filename     = hiera('downloads::java::filename',"jdk-${java_version}-linux-x64.rpm")
  $java_dl_url       = hiera('downloads::java::url','http://download.oracle.com/otn-pub/java/jdk/8u65-b17/jdk-8u65-linux-x64.rpm')

  $maven_version     = hiera('downloads::maven::version','3.3.9')
  $maven_filename    = hiera('downloads::maven::filename',"apache-maven-${maven_version}-bin.tar.gz")
  $maven_dl_url      = hiera('downloads::maven::url',"http://apache.osuosl.org/maven/maven-3/${maven_version}/binaries/${maven_filename}")

  $jbds_filename     = hiera('downloads::jbds::filename','jboss-devstudio-9.0.0.GA-CVE-2015-7501-installer-eap.jar')
}