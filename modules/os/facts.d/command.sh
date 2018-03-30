#!/bin/sh

cmd=`basename $0 .sh`
result=`$cmd 2>/dev/null`

echo "$cmd=$result"
