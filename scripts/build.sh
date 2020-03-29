#!/bin/bash

dockerfile=$1
tag=$2
target=$3

docker --config .docker build \
    --file "${dockerfile}" \
    --build-arg vcs_ref="${vcs_ref}" \
    --build-arg build_date="$(date --rfc-3339 ns)" \
    --build-arg version="${duplicity_version}" \
    --build-arg prefix="${prefix_version}" \
    --build-arg tag_version="${tag_version}" \
    --target "${target}" \
    --tag "${tag}" \
    .
docker --config .docker push "${tag}"
