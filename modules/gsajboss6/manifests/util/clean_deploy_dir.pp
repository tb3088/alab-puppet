# Delete specified instance deploy dir files
#
# Instance is found using Hiera and if no delete pattern provided, Hiera is used to locate them.

define gsajboss6::util::clean_deploy_dir
(
  $app_name = $title,
  $delete_patterns = [],
)
{
  include stdlib

  $apps = hiera_hash('applications')
  $app = $apps[$app_name]
  $instance = $app['instance']
  $hiera_delete_patterns = $app['delete_patterns']

  if $delete_patterns == [] {
    # If no patterns are provided, use Hiera-provided ones:
    if is_array($hiera_delete_patterns) {
      $patterns = $hiera_delete_patterns
    } else {
      $patterns = []
    }
  } else {
    $patterns = $delete_patterns
  }

  # Since there may be multiple patterns for a single instance, we must append to delete_patterns:
  Gsajboss6::Util::Delete_files <| title == $instance |> {
    delete_patterns +> $patterns,
  }

}
