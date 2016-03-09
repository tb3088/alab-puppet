# Deploy files to an instance's deploy directory

define gsajboss6::util::deploy_files (
  $instance,
  $source = [],
  $owner = 'jboss',
  $group = 'jboss',
  $mode = '0640',
)
{
  validate_array($source)

  if ($source != []) {
    file { $title:
      ensure       => directory,
      source       => $source,
      owner        => $owner,
      group        => $group,
      mode         => $mode,
      recurse      => true,
      purge        => true,
      sourceselect => all,
      notify       => Gsajboss6::Util::Restart[$instance],
    }
  }
}
