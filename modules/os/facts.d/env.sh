#!/bin/sh

cmd=`basename $0 .sh`

echo "$cmd=${!cmd}"
