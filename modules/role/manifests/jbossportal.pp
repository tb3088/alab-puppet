# Role for jbossPortal servers

class role::jbossportal (
      $assist_web_version          = $applications::params::assist_web_version,
      $assist_web_services_version = $applications::params::assist_web_services_version,
      $static_version              = $applications::params::static_version,
      $liferay_version             = $applications::params::liferay_version,
      $sso_version                 = $applications::params::sso_version,
) inherits applications::params
{

  class { 'applications::assist_web':
    version => $assist_web_version,
  }
  class { 'applications::assist_web_services':
    version => $assist_web_services_version,
  }
  class { 'applications::static':
    version => $static_version,
  }
  class { 'applications::liferay':
    version => $liferay_version,
  }
  class { 'applications::sso':
    version => $sso_version,
  }
}
