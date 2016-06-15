# Role for jbossApps servers

class role::jbossapps (
  $catalog_version          = $applications::params::catalog_version,
  $cpet_version             = $applications::params::cpet_version,
  $accrual_version          = $applications::params::accrual_version,
  $agreement_version        = $applications::params::agreement_version,
  $billing_version          = $applications::params::billing_version,
  $fpds_integration_version = $applications::params::fpds_integration_version,
  $omis_version             = $applications::params::omis_version,
  $birt_app_version         = $applications::params::birt_app_version,
  $birt_reports_version     = $applications::params::birt_reports_version,
  $timesheets_version       = $applications::params::timesheets_version,
  $baar_mock_version        = $applications::params::baar_mock_version,
  $deploy_baar_mock         = $applications::params::deploy_baar_mock,
) inherits applications::params
{

  class { 'applications::catalog':
    version => $catalog_version,
  }
  class { 'applications::cpet':
    version => $cpet_version,
  }
  class { 'applications::accrual':
    version => $accrual_version,
  }
  class { 'applications::agreement':
    version => $agreement_version,
  }
  class { 'applications::billing':
    version => $billing_version,
  }
  class { 'applications::fpds_integration':
    version => $fpds_integration_version,
  }
  class { 'applications::omis':
    version => $omis_version,
  }
  class { 'applications::birt_app':
    version => $birt_app_version,
  }
  class { 'applications::birt_reports':
    version => $birt_reports_version,
  }
  class { 'applications::timesheets':
    version => $timesheets_version,
  }

  if $deploy_baar_mock {
    class { 'applications::baar_mock':
      version => $baar_mock_version,
    }
  }
}
