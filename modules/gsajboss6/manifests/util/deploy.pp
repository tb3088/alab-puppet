# Set up the instance for an application

define gsajboss6::util::deploy
(
  $app_name = $title,
  $deploy_dir = 'UNSET',
  $source = [],
  $version = 'UNSET',
)
{
  include stdlib

  $apps = hiera_hash('applications')
  $app = $apps[$app_name]
  $instance = $app['instance']
  $build_dirs = $app['build_dirs']
  $app_version = $version ? {
    'UNSET' => hiera("versions::${app_name}"),
    default => $version,
  }

  $deploy_to = $deploy_dir ? {
    'UNSET' => "/opt/sw/jboss/gsaconfig/instances/${instance}/server/instanceconfig/deployments/",
    default => $deploy_dir,
  }

  if $source == [] {
    # If no source is provided, use Hiera-provided build folders for the hiera-provided version:
    $sources = suffix(prefix($build_dirs , 'puppet:///builds/'), "/${app_version}/")
  } else {
    $sources = $source
  }

  validate_array($sources)

  # Add files to the list of those to deploy:
  Gsajboss6::Util::Deploy_files <| title == $deploy_to |> {
    source +> $sources,
  }

}
