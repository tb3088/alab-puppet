#!/bin/bash

set -eo pipefail

curl='curl --silent'
meta_url='http://169.254.169.254/latest/meta-data'

region=`$curl $meta_url/placement/availability-zone | sed -e 's/[a-z]$//'`
instance_id=${1:-`$curl $meta_url/instance-id`}

set +x
aws ec2 describe-tags --region $region --filters "Name=resource-id,Values=$instance_id" --output text | \
    awk '$2 ~ /^puppet/ { sub(/^puppet\./, "", $2); printf("%s=%s\n", $2, $NF) }'
