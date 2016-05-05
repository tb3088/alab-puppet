# Module to install GSA JBoss packages.

class gsajboss6{
  require gsajboss6::packages
  require applications::jboss_modules
  require gsajboss6::keystores
}
