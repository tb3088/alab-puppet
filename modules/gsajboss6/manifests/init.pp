# Module to install GSA JBoss packages.

class gsajboss6 {
# define magic paths via Hiera, eg.
# JBOSS_TOP="/opt/sw/jboss"
# INSTANCE="<%= @instance %>"
# JBOSS_HOME="/opt/sw/jboss/jboss/jboss-eap-6.4"
# JAVA_HOME="/opt/sw/jboss/java/jdk1.8.0_131"
# JBOSS_INSTANCE_LOGDIR="/logs/jboss/<%= @instance %>"

# is 'require' correct? does 'keystores' or jboss_modules have resources that depend on items in 'packages'?

  require gsajboss6::packages
  require applications::jboss_modules
  require gsajboss6::keystores
}
