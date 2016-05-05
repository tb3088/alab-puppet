# Parameters for application classes
#
# All version numbers will default to their Hiera versions,
# and if the Hiera versions are not present, in most cases
# will default to the value of 'baseline'.

class applications::params {
  $jboss_modules_version = hiera('versions::jboss_modules', 'prototype')

  $accrual_version = hiera('versions::accrual', 'baseline')
  $agreement_version = hiera('versions::agreement', 'baseline')
  $assist_web_version = hiera('versions::assist_web', 'baseline')
  $assist_web_services_version = hiera('versions::assist_web_services', 'baseline')
  $baar_mock_version = hiera('versions::baar_mock', 'FY15QX_Aug_Qrtly')
  $billing_version = hiera('versions::billing', 'baseline')
  $birt_app_version = hiera('versions::birt_app', 'baseline')
  $birt_reports_version = hiera('versions::birt_reports', 'baseline')
  $catalog_version = hiera('versions::catalog', 'baseline')
  $cpet_version = hiera('versions::cpet', 'baseline')
  $cprm_version = hiera('versions::cprm', 'baseline')
  $edbpm_version = hiera('versions::edbpm', 'baseline')
  $fpds_integration_version = hiera('versions::fpds_integration', 'baseline')
  $funding_version = hiera('versions::funding', 'baseline')
  $gsa_paygov_version = hiera('versions::gsa_paygov', 'baseline')
  $itoms_version = hiera('versions::itoms', 'baseline')
  $itss_version = hiera('versions::itss', 'baseline')
  $itss_validate_ccr_version = hiera('versions::itss_validate_ccr', 'baseline')
  $liferay_version = hiera('versions::liferay', 'baseline')
  $timesheets_version = hiera('versions::timesheets', 'baseline')
  $omis_version = hiera('versions::omis', 'baseline')
  $portfolio_version = hiera('versions::portfolio', 'baseline')
  $rba_attach_version = hiera('versions::rba_attach', 'baseline')
  $rba_scheduler_version = hiera('versions::rba_scheduler', 'baseline')
  $sso_version = hiera('versions::sso', ' FY13QX_Registration ')
  $static_version = hiera('versions::static', 'baseline')
  $support_tools_version = hiera('versions::support_tools', 'baseline')
  $tos_version = hiera('versions::tos', 'baseline')
  $web_audit_admin_version = hiera('versions::web_audit_admin', 'baseline')

  $deploy_baar_mock = hiera('deploy_baar_mock', false)
}
