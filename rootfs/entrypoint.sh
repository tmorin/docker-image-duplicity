#!/usr/bin/env bash

declare -p | grep -Ev 'BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|UID' > /container.env

if [[ $1 == 'test-docker-image' ]]; then
    test-setup-cron && test-duplicity
else
    setup-cron && exec "$@"
fi
