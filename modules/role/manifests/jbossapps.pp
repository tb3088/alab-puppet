# Role for jbossApps servers

class role::jbossapps (
)
{
  class {
    [
      'applications::catalog',
      'applications::cpet',
      'applications::accrual',
      'applications::agreement',
      'applications::billing',
      'applications::fpds_integration',
      'applications::omis',
      'applications::birt_app',
      'applications::birt_reports',
      'applications::mobile_timesheet',
    ]:
  }
}
