# Configure the hosts file for a vLab JBoss server machine.

class machine_conf::hosts (
  $dmz_subnet_base     = '172.22.10',
  $backend_subnet_base = '172.22.11',
)
{
  require stdlib

  validate_ip_address("${dmz_subnet_base}.0")
  validate_ip_address("${backend_subnet_base}.0")

  host { $::fqdn:
    ip           => $::ipaddress,
    host_aliases => $::hostname,
  }

  host { 'lab5-portal.fas.gsarba.com':
    ip           => "${dmz_subnet_base}.4",
    host_aliases => 'assist-internal.fas.gsarba.com',
  }
  host { 'Lab5-was.itss.gsarba.com':
    ip           => "${dmz_subnet_base}.5",
    host_aliases => ['Lab5-apachePrx2','Lab5-apachePrx2.itss.gsarba.com','Lab5-was','loadbalancer-int.itss.gsarba.com','loadbalancer_int.itss.gsarba.com','tos','tos.fas.gsarba.com'],
  }
  host { 'Lab5-domExtran1.fas.gsarba.com':
    ip           => "${dmz_subnet_base}.8",
    host_aliases => ['Lab5-domExtran1','Lab5-tos.fas.gsarba.com','domextran2','domextran2.fas.gsarba.com','domino','domino.fas.gsarba.com']
  }
  host { 'Lab5-reports.fas.gsarba.com':
    ip           => "${backend_subnet_base}.19",
    host_aliases => 'lab5-ofm.fas.gsarba.com',
  }
  host { 'lab5-domphobos.fas.gsarba.com':
    ip           => "${backend_subnet_base}.28",
    host_aliases => 'lab5-domphobos',
  }
  host { 'Lab5-nbaOMIS.fas.gsarba.com':
    ip           => "${backend_subnet_base}.27",
    host_aliases => 'Lab5-nbaOMIS',
  }
  host { 'Lab5-rbaCODB.fas.gsarba.com':
    ip           => "${backend_subnet_base}.20",
    host_aliases => ['Lab5-rbaCODB','Lab5-rbaCODB.itss.gsarba.com'],
  }
  host { 'lab5-splunkpuppet.fas.gsarba.com':
    ip           => "${backend_subnet_base}.23",
    host_aliases => ['puppet','squid','puppet.fas.gsarba.com']
  }
  host { 'Lab5-AD.gsarba.com':
    ip           => "${backend_subnet_base}.29",
    host_aliases => 'Lab5-AD',
  }
  host { 'vlab-mailserver.fas.gsarba.com':
    ip           => "${backend_subnet_base}.30",
    host_aliases => 'vlab-mailserver',
  }

}
