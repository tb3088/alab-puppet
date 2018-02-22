#!/bin/bash

key=`basename $0 .sh`
[ -n "$key" ] || exit 1

echo "$key=`puppet config print --section ${SECTION:-user} $key 2>/dev/null`"
