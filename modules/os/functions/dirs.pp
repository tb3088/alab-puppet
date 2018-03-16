# FIXME this ONLY works without side-effects if $path is an absolute (or possibly './xxx')
function os::dirs(String $path) >> Array {
  include stdlib

  # FIXME check first char for '.' or '/'
  #FIXME convert to absolute path which will also squash '..'
  if ($path == undef) or $path.empty() 
  # or 
    # (($path.length() == 1) and 
       # (($path[0] == $facts['os']['separator']) or
        # ($path[0] == '.')))
    { return nil }

  # recursion
  #return [ $path ] << os::dirs(dirname($path))
  # need to reverse_each($dirs) to properly consume!
  
  # iterators
  $fragments = split(expand_path($path), $os::separator['file'])
  # $dirs = reduce($fragments, []) |$memo, $value| {
    # $dir = join([ $memo[length($memo)] ] << $value, $::File::Separator)
    # [ $memo ] << $dir
  # }

  $dirs = map($fragments) |$index, $value| {
    # ignore $value
    join($fragments[0, $index + 1], $os::separator['file'])
  }
  
  notify { "inside dirs() results in ${dirs}": }
  return unique($dirs)
}