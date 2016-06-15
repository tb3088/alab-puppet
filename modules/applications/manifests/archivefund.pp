# RBA ITSSArchiveFundWeb application

class applications::archivefund (
  $version=$applications::params::archivefund_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'archivefund': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'archivefund':
    version => $version,
  }


  ## Place application customizations here.
}
