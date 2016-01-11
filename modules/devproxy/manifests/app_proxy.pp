# Module to configure nginx for local development.

class devproxy::app_proxy ($jboss_port = hiera(jboss::port,'8080')) {

  $use_local = hiera_array('use_local')

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


  # This is for VirtualBox with host port 8888 mapped to the appropriate guest jboss port. HTTPS is assumed.
  nginx::resource::upstream { 'vb_proxy':
    members => [ '127.0.0.1:8888', ],
  }


  nginx::resource::upstream { 'portal_proxy':
    members => [ '172.22.12.4:443', ],
  }


  # This is your locally running JBoss server. If you use a different port for JBoss, you will need to update here.
  nginx::resource::upstream { 'local_proxy':
    members => [ '127.0.0.1:8080', ],
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

  if 'ROOT' in $use_local {
    $liferay_proxy = 'http://local_proxy'
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
    add_header    => {
      'X-Frame-Options'        => 'DENY',
      'X-Content-Type-Options' => 'nosniff',
      'X-XSS-Protection'       => '"1; mode=block"',
    },
  }

  # For debugging truststores and such things:
  nginx::resource::location { '/server-debug':
    proxy            => 'http://local_proxy/server-debug',
    vhost            => '*.gsarba.com',
    ssl              => true,
    ssl_only         => true,
    proxy_set_header => [
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-Forwarded-Proto $scheme'
    ],
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'itoms-struts' in $use_local {
    $itoms_struts_proxy = 'http://local_proxy/itoms-struts'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'ITSSValidateCCRProjWeb' in $use_local {
    $itssvalidateccrprojweb_proxy = 'http://local_proxy/ITSSValidateCCRProjWeb'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'omis' in $use_local {
    $omis_proxy = 'http://local_proxy/omis'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  # If you are developing static you may want to point this location directly at your filesystem.
  if 'static' in $use_local {
    $static_proxy = 'http://local_proxy/static'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'ITSSValidateWeb' in $use_local {
    $itssvalidateweb_proxy = 'http://local_proxy/ITSSValidateWeb'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'FPDSIntegrationService' in $use_local {
    $fpdsintegrationservice_proxy = 'http://local_proxy/FPDSIntegrationService'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'gsapaygov' in $use_local {
    $gsapaygov_proxy = 'http://local_proxy/gsapaygov'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'agreement-web' in $use_local {
    $agreement_web_proxy = 'http://local_proxy/agreement-web'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'tos' in $use_local {
    $tos_proxy = 'http://local_proxy/tos'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'birt' in $use_local {
    $birt_proxy = 'http://local_proxy/birt'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'waa' in $use_local {
    $waa_proxy = 'http://local_proxy/waa'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'assist-web' in $use_local {
    $assist_web_proxy = 'http://local_proxy/assist-web'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'IIMAInvoiceImageRetrieverWeb' in $use_local {
    $iimainvoiceimageretrieverweb_proxy = 'http://local_proxy/IIMAInvoiceImageRetrieverWeb'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'cpet' in $use_local {
    $cpet_proxy = 'http://local_proxy/cpet'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  # Liferay
  if 'ROOT' in $use_local {
    $root_proxy = 'http://local_proxy/ROOT'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'IIMAInvoiceXMLUpdateWeb' in $use_local {
    $iimainvoicexmlupdateweb_proxy = 'http://local_proxy/IIMAInvoiceXMLUpdateWeb'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'FedsimTimesheet' in $use_local {
    $fedsimtimesheet_proxy = 'http://local_proxy/FedsimTimesheet'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'gwac-pam-web' in $use_local {
    $gwac_pam_web_proxy = 'http://local_proxy/gwac-pam-web'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'catalog' in $use_local {
    $catalog_proxy = 'http://local_proxy/catalog'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'rba-attach-web' in $use_local {
    $rba_attach_web_proxy = 'http://local_proxy/rba-attach-web'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'services' in $use_local {
    $services_proxy = 'http://local_proxy/services'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'ITSSPerfProjWeb' in $use_local {
    $itssperfprojweb_proxy = 'http://local_proxy/ITSSPerfProjWeb'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'SupportTools' in $use_local {
    $supporttools_proxy = 'http://local_proxy/SupportTools'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'rba_modernization' in $use_local {
    $rba_modernization_proxy = 'http://local_proxy/rba_modernization'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'ITSSSupportToolsWeb' in $use_local {
    $itsssupporttoolsweb_proxy = 'http://local_proxy/ITSSSupportToolsWeb'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'ITSSFundWeb' in $use_local {
    $itssfundweb_proxy = 'http://local_proxy/ITSSFundWeb'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'opensso' in $use_local {
    $opensso_proxy = 'http://local_proxy/opensso'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'XMLUpdate' in $use_local {
    $xmlupdate_proxy = 'http://local_proxy/XMLUpdate'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'rba-servicedesk-web' in $use_local {
    $rba_servicedesk_web_proxy = 'http://local_proxy/rba-servicedesk-web'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'ITSSArchiveFundWeb' in $use_local {
    $itssarchivefundweb_proxy = 'http://local_proxy/ITSSArchiveFundWeb'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'accrual-web' in $use_local {
    $accrual_web_proxy = 'http://local_proxy/accrual-web'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


  if 'billing-web' in $use_local {
    $billing_web_proxy = 'http://local_proxy/billing-web'
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
    proxy_redirect   => 'http://127.0.0.1:8080 /',
  }


}