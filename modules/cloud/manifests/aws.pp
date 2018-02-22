class common::cloud::aws {
  #FIXME common::cloud::aws inherits common::cloud

  # uses facter 'customer?hash'
  #buckets=hash of conf, software etc
  #commands=hash of s3copy, metadata query, etc.
  # set facters by querying EC2 metadata.

  # seefacter['ec2_metadata'']

# $meta_url = 'http://169.254.169.254/'
  $region  = regsubst($::facts['ec2_metadata']['placement']['availability-zone'], '[a-z]$', '')
  $buckets = {
        software  => "${::facts['customer_hash']}-software",
        configs   => "${::facts['customer_hash']}-configs",
        logs      => "${::facts['customer_hash']}-logs"
  }

  notice("i'm in ${name} or aws")


}
