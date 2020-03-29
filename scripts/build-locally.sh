#!/bin/bash

duplicity_version="0.8.12"
prefix_version=".1612"
vcs_ref="unknown"
tag_image="thibaultmorin/duplicity"
tag_version="$duplicity_version-amd64"

function build {
    dockerfile=$1
    tag=$2
    target=$3
    echo "------ build ${tag} ------"
    docker build \
        --file "${dockerfile}" \
        --build-arg vcs_ref="${vcs_ref}" \
        --build-arg build_date="$(date --rfc-3339 ns)" \
        --build-arg version="${duplicity_version}" \
        --build-arg prefix="${prefix_version}" \
        --build-arg tag_version="${tag_version}" \
        --target "${target}" \
        --tag "${tag}" \
        .
}

build "Dockerfile.no-backends" "${tag_image}-no-backends:${tag_version}" \
&& build "Dockerfile.duplicity" "${tag_image}:${tag_version}" \
&& build "Dockerfile.flavors" "${tag_image}-cron:${tag_version}" "cron" \
&& build "Dockerfile.flavors" "${tag_image}-docker:${tag_version}" "docker" \
&& build "Dockerfile.flavors" "${tag_image}-mariadb:${tag_version}" "mariadb" \
&& build "Dockerfile.flavors" "${tag_image}-postgres:${tag_version}" "postgres" \
&& docker tag "${tag_image}:${tag_version}" "${tag_image}:latest" \
&& docker tag "${tag_image}-cron:${tag_version}" "${tag_image}-cron:latest" \
&& docker tag "${tag_image}-docker:${tag_version}" "${tag_image}-docker:latest" \
&& docker tag "${tag_image}-mariadb:${tag_version}" "${tag_image}-mariadb:latest" \
&& docker tag "${tag_image}-postgres:${tag_version}" "${tag_image}-postgres:latest"
