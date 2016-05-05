# Delete files matching a given list of patterns from the deploy directory

define gsajboss6::util::delete_files (
  $instance = $title,
  $delete_patterns = [],
)
{
  include stdlib

  validate_array($delete_patterns)
  validate_string($instance)

  # Since we take a list of patterns, we need to expand them out:
  if $delete_patterns != [] {
    $commands = prefix($delete_patterns, "rm -rf /opt/sw/jboss/jboss/jboss-eap-6.4/${instance}/deployments/")

    exec { $commands:
        path        => [ '/bin', '/usr/bin', ],
        refreshonly => true,
    }
  }
}
