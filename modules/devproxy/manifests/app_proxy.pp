# Module to configure nginx for local development.

class devproxy::app_proxy () {

  $use_local = hiera_hash('use_local')

  File {
    owner  => root,
    group  => root,
    mode   => '0600',
  }

  host { 'gsarba.com':
    ip           => '127.0.0.1',
    host_aliases => ['lab5-portal.fas.gsarba.com','lab5-was.itss.gsarba.com', 'tos.fas.gsarba.com'],
  }



  nginx::resource::upstream { 'rba_proxy':
    members => [ '172.22.12.5:443', ],
  }


  nginx::resource::upstream { 'portal_proxy_int':
    members => [ '172.22.12.4:444', ],
  }


  nginx::resource::upstream { 'tos_proxy':
    members => [ '172.22.12.16:443', ],
  }


  # fake proxy; do not use.
  nginx::resource::upstream { 'no_proxy':
    members => [ '120.0.0.1:443', ],
  }


  # This is for VirtualBox with host port 8888 mapped to the appropriate guest jboss port. HTTPS is assumed.
  nginx::resource::upstream { 'vb_proxy':
    members => [ '127.0.0.1:8888', ],
  }


  nginx::resource::upstream { 'portal_proxy':
    members => [ '172.22.12.4:443', ],
  }


  file { '/etc/nginx/ssl':
    ensure => directory,
  }
  file { '/etc/nginx/ssl/nginx-private.key.insecure':
    source => 'puppet:///modules/devproxy/ssl/nginx-private.key.insecure',
  }
  file { '/etc/nginx/ssl/gsarba.com.crt':
    source => 'puppet:///modules/devproxy/ssl/gsarba.com.crt',
  }

  if has_key($use_local,'ROOT') {
    $liferay_inst = $use_local['ROOT']
    $liferay_proxy = "http://${liferay_inst}_instance_proxy"
  } else {
    $liferay_proxy = 'https://portal_proxy'
  }

  nginx::resource::vhost { '*.gsarba.com':
    proxy         => $liferay_proxy,
    ssl           => true,
    listen_port   => '443',
    ssl_port      => '443',
    ssl_key       => '/etc/nginx/ssl/nginx-private.key.insecure',
    ssl_cert      => '/etc/nginx/ssl/gsarba.com.crt',
    ssl_protocols => 'TLSv1 TLSv1.1 TLSv1.2',
    ssl_ciphers   => 'EECDH+AESGCM:EDH+AESGCM:ECDHE-RSA-AES128-GCM-SHA256:AES256+EECDH:DHE-RSA-AES128-GCM-SHA256:AES256+EDH:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4',
    ## The following breaks some apps:
    # add_header    => {
    #   'X-Frame-Options'           => 'DENY',
    #   'X-Content-Type-Options'    => 'nosniff',
    #   'X-XSS-Protection'          => '"1; mode=block"',
    # },
  }



  if has_key($use_local,'itoms-struts') {
    $itoms_struts_inst = $use_local['itoms-struts']
    $itoms_struts_proxy = "http://${itoms_struts_inst}_instance_proxy/itoms-struts"
  } else {
    $itoms_struts_proxy = 'https://rba_proxy/itoms-struts'
  }
  nginx::resource::location { '/itoms-struts':
    proxy            => $itoms_struts_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'ITSSValidateCCRProjWeb') {
    $itssvalidateccrprojweb_inst = $use_local['ITSSValidateCCRProjWeb']
    $itssvalidateccrprojweb_proxy = "http://${itssvalidateccrprojweb_inst}_instance_proxy/ITSSValidateCCRProjWeb"
  } else {
    $itssvalidateccrprojweb_proxy = 'https://rba_proxy/ITSSValidateCCRProjWeb'
  }
  nginx::resource::location { '/ITSSValidateCCRProjWeb':
    proxy            => $itssvalidateccrprojweb_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'omis') {
    $omis_inst = $use_local['omis']
    $omis_proxy = "http://${omis_inst}_instance_proxy/omis"
  } else {
    $omis_proxy = 'https://portal_proxy/omis'
  }
  nginx::resource::location { '/omis':
    proxy            => $omis_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  # If you are developing static you may want to point this location directly at your filesystem.
  if has_key($use_local,'static') {
    $static_inst = $use_local['static']
    $static_proxy = "http://${static_inst}_instance_proxy/static"
  } else {
    $static_proxy = 'https://portal_proxy/static'
  }
  nginx::resource::location { '/static':
    proxy            => $static_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'ITSSValidateWeb') {
    $itssvalidateweb_inst = $use_local['ITSSValidateWeb']
    $itssvalidateweb_proxy = "http://${itssvalidateweb_inst}_instance_proxy/ITSSValidateWeb"
  } else {
    $itssvalidateweb_proxy = 'https://rba_proxy/ITSSValidateWeb'
  }
  nginx::resource::location { '/ITSSValidateWeb':
    proxy            => $itssvalidateweb_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'FPDSIntegrationService') {
    $fpdsintegrationservice_inst = $use_local['FPDSIntegrationService']
    $fpdsintegrationservice_proxy = "http://${fpdsintegrationservice_inst}_instance_proxy/FPDSIntegrationService"
  } else {
    $fpdsintegrationservice_proxy = 'https://portal_proxy/FPDSIntegrationService'
  }
  nginx::resource::location { '/FPDSIntegrationService':
    proxy            => $fpdsintegrationservice_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'gsapaygov') {
    $gsapaygov_inst = $use_local['gsapaygov']
    $gsapaygov_proxy = "http://${gsapaygov_inst}_instance_proxy/gsapaygov"
  } else {
    $gsapaygov_proxy = 'https://rba_proxy/gsapaygov'
  }
  nginx::resource::location { '/gsapaygov':
    proxy            => $gsapaygov_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'agreement-web') {
    $agreement_web_inst = $use_local['agreement-web']
    $agreement_web_proxy = "http://${agreement_web_inst}_instance_proxy/agreement-web"
  } else {
    $agreement_web_proxy = 'https://portal_proxy/agreement-web'
  }
  nginx::resource::location { '/agreement-web':
    proxy            => $agreement_web_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'tos') {
    $tos_inst = $use_local['tos']
    $tos_proxy = "http://${tos_inst}_instance_proxy/tos"
  } else {
    $tos_proxy = 'https://tos_proxy/tos'
  }
  nginx::resource::location { '/tos':
    proxy            => $tos_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  # Does not exist on server. Local only.
  if has_key($use_local,'server-debug') {
    $server_debug_inst = $use_local['server-debug']
    $server_debug_proxy = "http://${server_debug_inst}_instance_proxy/server-debug"
  } else {
    $server_debug_proxy = 'https://no_proxy/server-debug'
  }
  nginx::resource::location { '/server-debug':
    proxy            => $server_debug_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'birt') {
    $birt_inst = $use_local['birt']
    $birt_proxy = "http://${birt_inst}_instance_proxy/birt"
  } else {
    $birt_proxy = 'https://portal_proxy/birt'
  }
  nginx::resource::location { '/birt':
    proxy            => $birt_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'waa') {
    $waa_inst = $use_local['waa']
    $waa_proxy = "http://${waa_inst}_instance_proxy/waa"
  } else {
    $waa_proxy = 'https://tos_proxy/waa'
  }
  nginx::resource::location { '/waa':
    proxy            => $waa_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'assist-web') {
    $assist_web_inst = $use_local['assist-web']
    $assist_web_proxy = "http://${assist_web_inst}_instance_proxy/assist-web"
  } else {
    $assist_web_proxy = 'https://portal_proxy/assist-web'
  }
  nginx::resource::location { '/assist-web':
    proxy            => $assist_web_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'IIMAInvoiceImageRetrieverWeb') {
    $iimainvoiceimageretrieverweb_inst = $use_local['IIMAInvoiceImageRetrieverWeb']
    $iimainvoiceimageretrieverweb_proxy = "http://${iimainvoiceimageretrieverweb_inst}_instance_proxy/IIMAInvoiceImageRetrieverWeb"
  } else {
    $iimainvoiceimageretrieverweb_proxy = 'https://rba_proxy/IIMAInvoiceImageRetrieverWeb'
  }
  nginx::resource::location { '/IIMAInvoiceImageRetrieverWeb':
    proxy            => $iimainvoiceimageretrieverweb_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'cpet') {
    $cpet_inst = $use_local['cpet']
    $cpet_proxy = "http://${cpet_inst}_instance_proxy/cpet"
  } else {
    $cpet_proxy = 'https://portal_proxy/cpet'
  }
  nginx::resource::location { '/cpet':
    proxy            => $cpet_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  # Liferay
  if has_key($use_local,'ROOT') {
    $root_inst = $use_local['ROOT']
    $root_proxy = "http://${root_inst}_instance_proxy/ROOT"
  } else {
    $root_proxy = 'https://portal_proxy/ROOT'
  }
  nginx::resource::location { '/ROOT':
    proxy            => $root_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'IIMAInvoiceXMLUpdateWeb') {
    $iimainvoicexmlupdateweb_inst = $use_local['IIMAInvoiceXMLUpdateWeb']
    $iimainvoicexmlupdateweb_proxy = "http://${iimainvoicexmlupdateweb_inst}_instance_proxy/IIMAInvoiceXMLUpdateWeb"
  } else {
    $iimainvoicexmlupdateweb_proxy = 'https://rba_proxy/IIMAInvoiceXMLUpdateWeb'
  }
  nginx::resource::location { '/IIMAInvoiceXMLUpdateWeb':
    proxy            => $iimainvoicexmlupdateweb_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'FedsimTimesheet') {
    $fedsimtimesheet_inst = $use_local['FedsimTimesheet']
    $fedsimtimesheet_proxy = "http://${fedsimtimesheet_inst}_instance_proxy/FedsimTimesheet"
  } else {
    $fedsimtimesheet_proxy = 'https://portal_proxy/FedsimTimesheet'
  }
  nginx::resource::location { '/FedsimTimesheet':
    proxy            => $fedsimtimesheet_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'gwac-pam-web') {
    $gwac_pam_web_inst = $use_local['gwac-pam-web']
    $gwac_pam_web_proxy = "http://${gwac_pam_web_inst}_instance_proxy/gwac-pam-web"
  } else {
    $gwac_pam_web_proxy = 'https://rba_proxy/gwac-pam-web'
  }
  nginx::resource::location { '/gwac-pam-web':
    proxy            => $gwac_pam_web_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'catalog') {
    $catalog_inst = $use_local['catalog']
    $catalog_proxy = "http://${catalog_inst}_instance_proxy/catalog"
  } else {
    $catalog_proxy = 'https://portal_proxy/catalog'
  }
  nginx::resource::location { '/catalog':
    proxy            => $catalog_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'rba-attach-web') {
    $rba_attach_web_inst = $use_local['rba-attach-web']
    $rba_attach_web_proxy = "http://${rba_attach_web_inst}_instance_proxy/rba-attach-web"
  } else {
    $rba_attach_web_proxy = 'https://rba_proxy/rba-attach-web'
  }
  nginx::resource::location { '/rba-attach-web':
    proxy            => $rba_attach_web_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'services') {
    $services_inst = $use_local['services']
    $services_proxy = "http://${services_inst}_instance_proxy/services"
  } else {
    $services_proxy = 'https://portal_proxy/services'
  }
  nginx::resource::location { '/services':
    proxy            => $services_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'ITSSPerfProjWeb') {
    $itssperfprojweb_inst = $use_local['ITSSPerfProjWeb']
    $itssperfprojweb_proxy = "http://${itssperfprojweb_inst}_instance_proxy/ITSSPerfProjWeb"
  } else {
    $itssperfprojweb_proxy = 'https://rba_proxy/ITSSPerfProjWeb'
  }
  nginx::resource::location { '/ITSSPerfProjWeb':
    proxy            => $itssperfprojweb_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'SupportTools') {
    $supporttools_inst = $use_local['SupportTools']
    $supporttools_proxy = "http://${supporttools_inst}_instance_proxy/SupportTools"
  } else {
    $supporttools_proxy = 'https://rba_proxy/SupportTools'
  }
  nginx::resource::location { '/SupportTools':
    proxy            => $supporttools_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'rba_modernization') {
    $rba_modernization_inst = $use_local['rba_modernization']
    $rba_modernization_proxy = "http://${rba_modernization_inst}_instance_proxy/rba_modernization"
  } else {
    $rba_modernization_proxy = 'https://rba_proxy/rba_modernization'
  }
  nginx::resource::location { '/rba_modernization':
    proxy            => $rba_modernization_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'ITSSSupportToolsWeb') {
    $itsssupporttoolsweb_inst = $use_local['ITSSSupportToolsWeb']
    $itsssupporttoolsweb_proxy = "http://${itsssupporttoolsweb_inst}_instance_proxy/ITSSSupportToolsWeb"
  } else {
    $itsssupporttoolsweb_proxy = 'https://rba_proxy/ITSSSupportToolsWeb'
  }
  nginx::resource::location { '/ITSSSupportToolsWeb':
    proxy            => $itsssupporttoolsweb_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'ITSSFundWeb') {
    $itssfundweb_inst = $use_local['ITSSFundWeb']
    $itssfundweb_proxy = "http://${itssfundweb_inst}_instance_proxy/ITSSFundWeb"
  } else {
    $itssfundweb_proxy = 'https://rba_proxy/ITSSFundWeb'
  }
  nginx::resource::location { '/ITSSFundWeb':
    proxy            => $itssfundweb_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'opensso') {
    $opensso_inst = $use_local['opensso']
    $opensso_proxy = "http://${opensso_inst}_instance_proxy/opensso"
  } else {
    $opensso_proxy = 'https://portal_proxy_int/opensso'
  }
  nginx::resource::location { '/opensso':
    proxy            => $opensso_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'XMLUpdate') {
    $xmlupdate_inst = $use_local['XMLUpdate']
    $xmlupdate_proxy = "http://${xmlupdate_inst}_instance_proxy/XMLUpdate"
  } else {
    $xmlupdate_proxy = 'https://rba_proxy/XMLUpdate'
  }
  nginx::resource::location { '/XMLUpdate':
    proxy            => $xmlupdate_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'rba-servicedesk-web') {
    $rba_servicedesk_web_inst = $use_local['rba-servicedesk-web']
    $rba_servicedesk_web_proxy = "http://${rba_servicedesk_web_inst}_instance_proxy/rba-servicedesk-web"
  } else {
    $rba_servicedesk_web_proxy = 'https://rba_proxy/rba-servicedesk-web'
  }
  nginx::resource::location { '/rba-servicedesk-web':
    proxy            => $rba_servicedesk_web_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'ITSSArchiveFundWeb') {
    $itssarchivefundweb_inst = $use_local['ITSSArchiveFundWeb']
    $itssarchivefundweb_proxy = "http://${itssarchivefundweb_inst}_instance_proxy/ITSSArchiveFundWeb"
  } else {
    $itssarchivefundweb_proxy = 'https://rba_proxy/ITSSArchiveFundWeb'
  }
  nginx::resource::location { '/ITSSArchiveFundWeb':
    proxy            => $itssarchivefundweb_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'accrual-web') {
    $accrual_web_inst = $use_local['accrual-web']
    $accrual_web_proxy = "http://${accrual_web_inst}_instance_proxy/accrual-web"
  } else {
    $accrual_web_proxy = 'https://portal_proxy/accrual-web'
  }
  nginx::resource::location { '/accrual-web':
    proxy            => $accrual_web_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if has_key($use_local,'billing-web') {
    $billing_web_inst = $use_local['billing-web']
    $billing_web_proxy = "http://${billing_web_inst}_instance_proxy/billing-web"
  } else {
    $billing_web_proxy = 'https://portal_proxy/billing-web'
  }
  nginx::resource::location { '/billing-web':
    proxy            => $billing_web_proxy,
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    # proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


}
