#!/bin/bash
tag=$1
target=$2
docker --config .docker build \
    --build-arg vcs_ref="${vcs_ref}" \
    --build-arg build_date="$(date --rfc-3339 ns)" \
    --build-arg version="${duplicity_version}" \
    --build-arg prefix="${prefix_version}" \
    --target "${target}" \
    --tag "${tag}" \
    .
docker --config .docker push "${tag}"
