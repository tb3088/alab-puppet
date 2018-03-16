class cloud::aws inherits cloud (
    String $metadata_url,
  )
{
  include os
  
  #buckets=hash of conf, software etc
  #commands=hash of s3copy, metadata query, etc.
  # set facters by querying EC2 metadata.

  # seefacter['ec2_metadata'']

# $metadata_url = 'http://169.254.169.254/latest/'
  $region  = regsubst($facts['ec2_metadata']['placement']['availability-zone'], '[a-z]$', '')
  # also http://169.254.169.254/latest/dynamic/instance-identity/document/ | grep region
  # convert this to an external fact?


  notice("i'm in ${name} or aws")


}
