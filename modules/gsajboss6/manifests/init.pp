# Module to install GSA JBoss packages.

class gsajboss6 {
# define magic paths in a hash

# is 'require' correct? does 'keystores' or jboss_modules have resources that depend on items in 'packages'?

  require gsajboss6::packages
  require applications::jboss_modules
  require gsajboss6::keystores
}
