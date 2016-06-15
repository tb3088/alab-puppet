# Role for jbossRba servers

class role::jbossrba (
      $cprm_version              = $applications::params::cprm_version,
      $archivefund_version       = $applications::params::archivefund_version,
      $funding_version           = $applications::params::funding_version,
      $itoms_version             = $applications::params::itoms_version,
      $edbpm_version             = $applications::params::edbpm_version,
      $itss_version              = $applications::params::itss_version,
      $support_tools_version     = $applications::params::support_tools_version,
      $rba_scheduler_version     = $applications::params::rba_scheduler_version,
      $gsa_paygov_version        = $applications::params::gsa_paygov_version,
      $itss_validate_ccr_version = $applications::params::itss_validate_ccr_version,
      $rba_attach_version        = $applications::params::rba_attach_version,
) inherits applications::params
{
  class { 'applications::cprm':
    version => $cprm_version,
  }
  class { 'applications::archivefund':
    version => $archivefund_version,
  }  
  class { 'applications::funding':
    version => $funding_version,
  }
  class { 'applications::itoms':
    version => $itoms_version,
  }
  class { 'applications::edbpm':
    version => $edbpm_version,
  }
  class { 'applications::itss':
    version => $itss_version,
  }
  class { 'applications::support_tools':
    version => $support_tools_version,
  }
  class { 'applications::rba_scheduler':
    version => $rba_scheduler_version,
  }
  class { 'applications::gsa_paygov':
    version => $gsa_paygov_version,
  }
  class { 'applications::itss_validate_ccr':
    version => $itss_validate_ccr_version,
  }
  class { 'applications::rba_attach':
    version => $rba_attach_version,
  }
}
