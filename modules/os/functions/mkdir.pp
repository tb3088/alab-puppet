function common::mkdir (String[1] $path, String[4] $mode = '0755', Boolean $run = false, ) {

# technically a function should never change resources though this might be a good exception.
# Intended to unroll a path and create the intermediaries 
# could be called from 'Common::Directory' which would handle the case of multiple
# instantiations being requested.
# 
# if run=false return the structure, if true, do the actual create_resources()
#
# alternatively
# should return a data structure sorted so call create_resources againt. Can the keys be "anonymous"?
# construct the hash using '+' notation to build it in a "loop"? use Array insertion to build it in order.
#
#  $items = [
#    'sysdir_etc'  => { path => '/etc' },
#    'sysdir_temp' => { path => '/tmp', mode => '1777' }, # TODO enforce mount
#    'sysdir_var'  => { path => '/var' }, # TODO enforce mount
#  ]
#    create_resources(file, $items, { ensure => 'directory', mode => $mode['dir'] })
#
# glue
#  }

}

# maybe another like this?
#function common::mkdir(String $prefix, Array *$elements)) {