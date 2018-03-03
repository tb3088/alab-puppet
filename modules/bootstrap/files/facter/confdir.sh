#!/bin/bash

# WARNING! do NOT put any script that invokes 'puppet config print' in 'facts.d' 
# or other auto-processed directory or it will fork-bomb. Puppet will process
# facts but doesn't actually emit them.
#
#
# Usage: symlink file to ../puppet.sh

key=${1:-`basename $0 .sh`}
[ -n "$key" ] || exit 1

echo "$PREFIX$key=`puppet config print --section ${SECTION:-user} $key 2>/dev/null`"
