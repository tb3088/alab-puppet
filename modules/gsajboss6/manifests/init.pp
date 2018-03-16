# Module to install GSA JBoss packages.

class gsajboss6 (
    # NOTE: the lookup() here is deliberate (hack) since APL only works correctly if the
    # YAML structure is native. Doing a '%{lookup()}' inside a YAML document causes
    # conversion to String.
    #
    # This syntax should still allow the Class to be instantiated with arguments
    # and only resort to lookup() (and it's not-found defaults) on their absence.
    Hash $user = {
        'name'  => 'jboss',
        'uid'   => 201,
        'gid'   => 201,
        'home'  => '/opt/sw/jboss',
        #'comment' => undef,
        # TODO should be lookup('os::default.shell')
        'shell' => lookup('os::default.shell', String, undef, '/bin/bash')
        #'password' => undef,
    },
    Hash $group = {
        'name'  => 'jboss',
        'gid'   => 201
    }
  )
# define magic paths via Hiera, eg.
# JBOSS_TOP="/opt/sw/jboss"
# INSTANCE="<%= @instance %>"
# JBOSS_HOME="/opt/sw/jboss/jboss/jboss-eap-6.4"
# JAVA_HOME="/opt/sw/jboss/java/jdk1.8.0_131"
# JBOSS_INSTANCE_LOGDIR="/logs/jboss/<%= @instance %>"

{
  include os

  #FIXME get os::dirs() working
  # os::directory { [ 
    # lookup('gsajboss6::dirs' |d| lambda first level keys)
    # ] :
  # }

  group { 'jboss' : * => $group }
  user { 'jboss'  : * => $user, managehome => true }

  #TODO rationalize paths
  file {[
        '/opt',
        '/opt/sw',
        '/logs',
    ]:
    ensure  => directory,
    *       => lookup('os::default.directory')
  }

  File { owner => $user['name'], group => $group['name'] }

  file {[
        '/logs/jboss',
        "${user['home']}/logs",
        "${user['home']}/logs/config",
        "${user['home']}/appconfig",
        "${user['home']}/appconfig/jboss",
    ]:
    ensure  => directory,
    #FIXME remove hard-coded paths
    require => [ User['jboss'], File['/opt/sw'] ],
  }

  # is 'require' correct? does 'keystores' or jboss_modules have resources that depend on items in 'packages'?
  ##include applications::jboss_modules
  #include "${name}::keystores"
}
