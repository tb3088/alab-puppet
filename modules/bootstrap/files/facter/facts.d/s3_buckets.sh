#!/bin/bash

function runv() {
    1>&2 echo "+ $*"
    "$@"
}

set -eo pipefail

curl='curl --silent --fail'
meta_url='http://169.254.169.254/latest/meta-data'
: ${REGION:=`$curl $meta_url/placement/availability-zone | sed -e 's/[a-z]$//'`}
#instance_id=`$curl $meta_url/instance-id`

: ${PREFIX:=`basename $0 .sh`}
: ${FORMAT:=text}

case "${FORMAT,,}" in
    text)  
        awk_begin='BEGIN { printf("%s=[ ", prefix); }'
        awk_printf='"\x27%s\x27, ", $3'
        awk_end='END { printf("]\n"); }'
        ;;&
    json)
        post_format="|python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)'"
        ;&
    yaml)
        awk_begin='BEGIN { printf("---\n%s:\n", prefix); }'

        # wrap in single-quotes, because YAML parser
        awk_printf='"  - \x27%s\x27\n", $3'
        ;&
    text|yaml|json)
        # NOTE - 'filter' and 'key' are by definition mutually exclusive!
        read -r -d '' cmd_awk <<_EOF || true
|awk -v prefix='$PREFIX' -v filter='$FILTER' -v key='$key' '
    $awk_begin
    \$3 ~ filter {
        if (length(key) != 0) { \$3 = \$1; \$1 = key; }
        printf($awk_printf)
    }
    $awk_end
'
_EOF
        ;;
    *)  >&2 echo "unsupported format ($FORMAT)"; exit 1
esac


# '--debug' screws up output so DO NOT use except interactive
cmd="aws ${PROFILE+ --profile $PROFILE} --region ${REGION:?}"
cmd+=" s3 ls s3://"
                
${DEBUG+runv} eval "$cmd $@ $cmd_awk $post_format"



# potential way to generate Yaml, first line, print PREFIX:\n and then for every element in array if split, indent one space for every index in array. use
# x=3; awk -v x=$x '{printf "%" x "s%s\n", "", $0}' file
# https://www.math.utah.edu/docs/info/gawk_7.html

# awk '
# BEGIN {
  # print "---\n"
# }
# NR == 1 {
  # nc = NF
  # for(c = 1; c <= NF; c++) {
    # h[c] = $c
  # }
# }
# NR > 1 {
  # for(c = 1; c <= nc; c++) {
    # printf h[c] ": " $c "\n"
  # }
  # print ""
# }'
