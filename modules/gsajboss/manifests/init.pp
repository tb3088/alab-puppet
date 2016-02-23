# Module to install GSA JBoss packages.

class gsajboss{
  include gsajboss::user
  include gsajboss::packages
  include gsajboss::local_mods
}