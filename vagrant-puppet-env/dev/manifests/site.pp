## This part is just to supress a warning. Continue on for the main portions of the file
# Turn off virtual packages unless overridden by Hiera:
if versioncmp($::puppetversion,'3.6.1') >= 0 {
  $allow_virtual_packages = hiera('allow_virtual_packages',false)

  Package {
    allow_virtual => $allow_virtual_packages,
  }
}

class {'local_mods':}->

class { 'applications::cprm': }