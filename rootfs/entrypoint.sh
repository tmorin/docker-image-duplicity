#!/usr/bin/env bash

declare -p | grep -Ev 'BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|UID' > /container.env

if [[ $1 == 'test-docker-image' ]]; then
    test-setup-cron && test-duplicity
elif [[ $1 == 'restore' ]]; then
    setup-cron && exec execute-restore
else
    setup-cron && exec "$@"
fi
