function os::mode_read (Integer $who) >> Integer {
#  sprintf("%+04d", $os::perms['read'] * ($who))
  $os::perms['read'] * $who
}
