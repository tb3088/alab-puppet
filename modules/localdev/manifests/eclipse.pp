# Module to install set up for local development 

class localdev::eclipse{
  
  ::eclipse{ 'eclipse-java':
    downloadurl  => 'http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/luna/SR2/eclipse-java-luna-SR2-linux-gtk-x86_64.tar.gz',
    downloadfile => 'eclipse-java-luna-SR2-linux-gtk-x86_64.tar.gz',
  }
  
  ::eclipse::plugin{ 'egit':
    pluginrepositories => 'http://download.eclipse.org/releases/luna/',
    pluginius          => ['org.eclipse.egit.feature.group',],
  }

}