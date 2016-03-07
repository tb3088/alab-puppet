# Role for jbossRba servers

class role::jbossrba (
)
{
  class {
    [
      'applications::cprm',
      'applications::funding',
      'applications::itoms',
      'applications::edbpm',
      'applications::itss',
      'applications::support_tools',
      'applications::rba_scheduler',
      'applications::gsa_paygov',
      'applications::itss_validate_ccr',
      'applications::rba_attach',
    ]:
  }
}
