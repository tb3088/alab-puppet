function os::mode_set (Integer $mode, $who) >> String {
  os::mode($mode * $who)
}
