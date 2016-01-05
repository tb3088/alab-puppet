## This part is just to supress a warning. Continue on for the main portions of the file
# Turn off virtual packages unless overridden by Hiera:
if versioncmp($::puppetversion,'3.6.1') >= 0 {
  $allow_virtual_packages = hiera('allow_virtual_packages',false)

  Package {
    allow_virtual => $allow_virtual_packages,
  }
}


## This is the heart of the site.pp file. We want to include the classes we wish to test.
## Here we are including two of them. One which accesses Hiera and another which 
## accesses the 'builds' file server. For demonstration purposes they are being included
## via two different methods.

# If you don't need to change any parameters you can just include the class like this:
include hiera_test

# This does the same thing as include but lets you change parameters if you need to:
class { 'builds_test':
}

include gsajboss::user
include localdev