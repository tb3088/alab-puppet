# *must* be String or Octal (leading '0')

function os::mode (Integer $mode) >> String {
  #TODO call puppet/util/symbolic_file_mode.rb::normalize_symbolic_mode(mode)
  return sprintf("%#o", mode) if mode =~ /^0o?/
  
  sprintf("%05d", $mode)
}
