# CPRM application

class applications::liferay {

  # Make sure the instance is present:
  applications::util::app_init { 'liferay': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'liferay': }


  ## Place application customizations here.
}
