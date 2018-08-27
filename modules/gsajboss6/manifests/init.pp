# install GSA JBoss packages and supporting scripts

class gsajboss6 (
    # NOTE: the lookup() here is deliberate since APL only works correctly if the
    # YAML structure is native. Doing a '%{lookup()}' inside a YAML document causes
    # conversion to String.

    Hash $user,
    Hash $group,
    #TODO define skeleton structure
    Hash $dirs,
  )
# define magic paths via Hiera, eg.
# JBOSS_ROOT="/opt/sw/jboss"
# INSTANCE="<%= @instance %>"
# JBOSS_HOME="/opt/sw/jboss/jboss/jboss-eap-6.4"
# JAVA_HOME="/opt/sw/jboss/java/jdk1.8.0_131"
# JBOSS_INSTANCE_LOGDIR="/logs/jboss/<%= @instance %>"

{
  include stdlib
  include os

  #FIXME get os::dirs() working
  # os::directory { [ 
    # lookup('gsajboss6::dirs' |d| lambda first level keys)
    # ] :
  # }

  group { 'jboss' : * => $group }
  user { 'jboss'  : * => $user, managehome => true }

  File { owner => $user['name'], group => $group['name'] }
  Exec { user  => $user['name'], group => $group['name'] }

  # #TODO create array pragmatically with each([suffixes]) |$item] { list + "$prefix/$item" }
  # file {[
        # '/logs',    #FIXME garbage
        # $dirs['log']['path'], # FIXME garbage
        # "${dirs['root']['path']}/logs",
        # "${dirs['root']['path']}/logs/config",
    # ] :
    # ensure  => directory,
  # }

  contain gsajboss6::install

  #FIXME use PuppetForge module instead
  contain gsajboss6::java

}
