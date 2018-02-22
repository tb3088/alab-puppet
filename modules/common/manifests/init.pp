class common {
  include os

  $source_hierarchy = [
    "_prefix_/${facts['fqdn']}",
    "_prefix_/${facts['hostname']}",
    "_prefix_/${facts['domain']}",
    "_prefix_/${facts['site']}/${facts['environment']}/${facts['role']}",
    "_prefix_/${facts['site']}/${facts['role']}",
    "_prefix_/${facts['site']}",
    "_prefix_/${facts['environment']}/${facts['role']}",
    "_prefix_/${facts['environment']}",
    "_prefix_/${facts['role']}",
    '_prefix_/',
 ]


  # XXX can be defined as ::$name::package? instead of package_wrapper?
  define package_wrapper (
      String $ensure = undef,
      String $provider = undef,
      String $url = undef 
    ) {

    #TODO
    # detect if FQ package name or just the title - grab last 4 char?
    #FIXME suffix is bogus
    $pkg_name = "${title}-${version}.${arch}.rpmdeb"

# debian: pool = { main, contrib, non-free},
# ubuntu main, multiverse, restricted, universe
# http://ftp.us.debian.org/debian/pool/main/<1st letter, except libs use first 4>/<pkgName>/pkgName_<ver>_<arch>deb
# debian uses 'all', amd64, i386, ia64 ... compare to Facter?
                  #     source => $url/$name-$version.$arch.$suffix
                  # eg:  389-adminutil-devel  1.1.19-1.el6  x86_64  rpm
#
# ensure => latest, not supported by 'rpm'
# source => url, ignored by 'yum'
# put logc here to catch 'latest' & rpm or dpkg

    package { $title :
      ensure => $ensure,
      source => "${url}/${middle}/${pkg_name}"
    }
  }

# TODO - blanket creation should be done on fileserver, selectively on other profiles
#  create_resources(user, $::users)
#  create_resources(group, $::groups)
}
