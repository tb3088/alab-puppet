function common::parent(String $item = undef) {
  #TODO handle '/' delimited and do 'basename()'
  $item.empty() || regsubst($item, '::[^:]+$', '')
}