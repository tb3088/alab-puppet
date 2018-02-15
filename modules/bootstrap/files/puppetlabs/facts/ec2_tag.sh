#!/bin/bash

set -eo pipefail

function runv() {
    1>&2 echo "+ $*"
    "$@"
}

# using '.' pretends to be a structured fact during dereference but won't display as such with 'factor -p|yj'
prefix=${PREFIX-"`basename $0 .sh`."}
filter="$1"

curl='curl --silent'
meta_url='http://169.254.169.254/latest/meta-data'
region=`$curl $meta_url/placement/availability-zone | sed -e 's/[a-z]$//'`
instance_id=`$curl $meta_url/instance-id`

${DEBUG:+runv} aws ec2 describe-tags --region ${region:?} \
        --filters "Name=resource-id,Values=${instance_id:?}" \
        --output text 2>/dev/null | \
    awk -v prefix="$prefix" -v filter="$filter" '$2 !~ filter { gsub(/[^-[:alnum:]._:]/, "_", $2); printf("%s%s=%s\n", prefix, tolower($2), $NF) }'


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