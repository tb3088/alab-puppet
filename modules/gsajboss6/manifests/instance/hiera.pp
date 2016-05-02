# Use Hiera to create virtual resources for instances.
# Realize instances with
#    Gsajboss6::Instance<| title == 'instname' |>
# or
#    realize(Gsajboss6::Instance['instname'])

class gsajboss6::instance::hiera (
  $ensure = 'present',
)
{
  include stdlib

  $defaults = {
  }
    local => hiera('use_local',false)

  $instances = hiera_hash('instances')

  create_resources('@gsajboss6::instance', $instances, $defaults)
}
