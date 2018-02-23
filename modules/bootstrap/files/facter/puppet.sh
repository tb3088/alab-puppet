#!/bin/bash
#set -eo pipefail

function runv() {
    1>&2 echo "+ $*"
    "$@"
}

[ $# -eq 1 ] && key=$1

case "${FORMAT,,}" in
    yaml)
        # embedded ':' without whitespace should be safe. Else try 'value'.
        # https://stackoverflow.com/questions/11301650/how-to-escape-indicator-characters-i-e-or-in-yaml/22483116
        #
        # TODO: some trickery to further structure items
        # keys like ldap, max, plugin, report, ca, splay, agent, ssl_client, config, ca, host, 
        # http, http_proxy, various 'dir's
        awk_begin='BEGIN { printf("---\n%s:\n", prefix); }'
        awk_printf='printf("  %s: %s\n", $1, $3)'
        : ${PREFIX:=`basename $0 .sh`}
        ;;
    *)  awk_printf='printf("%s%s=%s\n", prefix, $1, $3)'
        : ${PREFIX:=`basename $0 .sh`.}
esac

# '--debug' screws up output so DO NOT use except interactive
cmd="${PUPPET:-puppet} config ${DEBUG+ --debug} ${VERBOSE+ --verbose} print --section ${SECTION:-user}"
read -r -d '' cmd_awk <<_EOF
awk -v prefix='$PREFIX' -v filter='$FILTER' -v key='$key' '
  $awk_begin
  \$1 ~ /Debug:/ { print; next; }
  \$1 ~ filter {
        if (length(key) != 0) { \$3 = \$1; \$1 = key; }
        $awk_printf 
    }
'
_EOF
                
${DEBUG+runv} eval "$cmd $@ | $cmd_awk"