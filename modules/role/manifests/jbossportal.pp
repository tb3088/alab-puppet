# Role for jbossPortal servers

class role::jbossportal (
)
{
  class {
    [
      'applications::assist_web',
      'applications::assist_web_services',
      'applications::static',
      'applications::liferay',
      'applications::sso',
    ]:
  }
}
