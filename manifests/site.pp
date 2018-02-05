## This part is just to supress a warning. Continue on for the main portions of the file
# Turn off virtual packages unless overridden by Hiera:
if versioncmp($::puppetversion,'3.6.1') >= 0 {
  $allow_virtual_packages = hiera('allow_virtual_packages',false)

  Package {
    allow_virtual => $allow_virtual_packages,
  }
}

File {
  backup => false,
}

class { 'machine_conf::jboss_user':
  uid => 512611,
  gid => 612611,
}

## An attempt to do it the way Danny intended and grab the installation packages from a yum repo wasn't working out.
## Commented it out for now; we can revisit this later if need be.
#class { 'machine_conf::repo':
#  repo_url => "http://9f360c3d418ff28d5eb0a57bc2b1f0a4-software.s3-website-us-east-1.amazonaws.com/software",
#}

class { 'gsajboss6::packages':
  install_from_packages => true,
}

# The assist box. As we progress through other instances more nodes will be added with node-specific configurations
node 'ip-172-16-0-81.ec2.internal' {
 
  ## This will vary based on the machine. So to install the 'apps' instance, you would declare instances::apps.
  class { 'instances::assist': }
}  
