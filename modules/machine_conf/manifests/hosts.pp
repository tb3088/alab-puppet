# Module to install set up for local development

class machine_conf::hosts {
  require stdlib

  host { $::fqdn:
    ip           => $::ipaddress,
    host_aliases => $::hostname,
  }

  host { 'lab5-portal.fas.gsarba.com':
    ip           => '172.22.10.4',
    host_aliases => 'assist-internal.fas.gsarba.com',
  }
  host { 'Lab5-was.itss.gsarba.com':
    ip           => '172.22.10.5',
    host_aliases => ['Lab5-apachePrx2','Lab5-apachePrx2.itss.gsarba.com','Lab5-was','loadbalancer-int.itss.gsarba.com','loadbalancer_int.itss.gsarba.com','tos','tos.fas.gsarba.com'],
  }
  host { 'Lab5-domExtran1.fas.gsarba.com':
    ip           => '172.22.10.8',
    host_aliases => ['Lab5-domExtran1','Lab5-tos.fas.gsarba.com','domextran2','domextran2.fas.gsarba.com','domino','domino.fas.gsarba.com']
  }
  host { 'Lab5-reports.fas.gsarba.com':
    ip           => '172.22.11.19',
    host_aliases => 'lab5-ofm.fas.gsarba.com',
  }
  host { 'lab5-domphobos.fas.gsarba.com':
    ip           => '172.22.11.28',
    host_aliases => 'lab5-domphobos',
  }
  host { 'Lab5-nbaOMIS.fas.gsarba.com':
    ip           => '172.22.11.27',
    host_aliases => 'Lab5-nbaOMIS',
  }
  host { 'Lab5-rbaCODB.fas.gsarba.com':
    ip           => '172.22.11.20',
    host_aliases => ['Lab5-rbaCODB','Lab5-rbaCODB.itss.gsarba.com'],
  }
  host { 'lab5-splunkpuppet.fas.gsarba.com':
    ip           => '172.22.11.23',
    host_aliases => ['puppet','squid','puppet.fas.gsarba.com']
  }
  host { 'Lab5-AD.gsarba.com':
    ip           => '172.22.11.29',
    host_aliases => 'Lab5-AD',
  }
  host { 'vlab-mailserver.fas.gsarba.com':
    ip           => '172.22.11.30',
    host_aliases => 'vlab-mailserver',
  }

}
