#!/bin/bash

set -eo pipefail

function runv() {
    1>&2 echo "+ $*"
    "$@"
}

${DEBUG:+runv} puppet config print --section ${SECTION:-user} "$@" | \
    awk -v prefix="${PREFIX-`basename $0 .sh`.}" -v filter="$FILTER" '$1 ~ filter { printf("%s%s=%s\n", prefix, $1, $3); }'
