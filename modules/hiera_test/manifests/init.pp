# This module is purely to test Hiera and print a value from it if successful.

class hiera_test {
  $fname = hiera('hiera_file')
  notify { "Hiera file: [${fname}]": }
}