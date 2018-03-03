#!/bin/bash

function runv() {
    1>&2 echo "+ $*"
    "$@"
}

# Only when ARGS is a single item is $cmd output reduced to just the value
[ $# -eq 1 ] && { key="$1"; shift; }
set -eo pipefail

: ${PREFIX:=`basename $0 .sh`}
: ${FORMAT:=text}

case "${FORMAT,,}" in
    text)
        awk_printf='"%s.%s=\x27%s\x27\n", prefix, $1, $3'
        ;;&
    json)
        post_format="|python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)'"
        ;&
    yaml)
        # embedded ':' without whitespace should be safe. Else try 'value'.
        # https://stackoverflow.com/questions/11301650/how-to-escape-indicator-characters-i-e-or-in-yaml/22483116
        #
        # TODO: some trickery to further structure items
        # keys like ldap, max, plugin, report, ca, splay, agent, ssl_client, config, ca, host, 
        # http, http_proxy, various 'dir's

        awk_begin='BEGIN { printf("---\n%s:\n", prefix); }'

        # wrap in single-quotes, because YAML parser
        awk_printf='"  %s: \x27%s\x27\n", $1, $3'
        ;&
    text|yaml|json)
        # NOTE - 'filter' and 'key' are by definition mutually exclusive!
        read -r -d '' cmd_awk <<_EOF || true
|awk -v prefix='$PREFIX' -v filter='$FILTER' -v key='$key' '
    $awk_begin
    \$1 ~ /Debug:/ { print; next; }
    \$1 ~ filter {
        if (length(key) != 0) { \$3 = \$1; \$1 = key; }
        printf($awk_printf)
    }
'
_EOF
        ;;
    *)  >&2 echo "unsupported format ($FORMAT)"; exit 1

esac

# '--debug' screws up output so DO NOT use except interactive
cmd="${PUPPET:-puppet} config ${DEBUG+ --debug} ${VERBOSE+ --verbose} print --section ${SECTION:-user}"
                
${DEBUG+runv} eval "$cmd $@ $cmd_awk $post_format"
