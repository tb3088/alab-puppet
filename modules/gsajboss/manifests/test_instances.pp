# Create JBoss instances (Use for testing only)

class gsajboss::test_instances {
  require gsajboss::packages

  gsajboss::instance { 'test1':
    base_port => '51000',
  }

  gsajboss::instance { 'test2':
    base_port => '52000',
  }
}