# docker-image-duplicity

![Build Images](https://github.com/tmorin/docker-image-duplicity/workflows/Build%20Images/badge.svg)

[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/thibaultmorin/duplicity?label=thibaultmorin%2Fduplicity)](https://hub.docker.com/r/thibaultmorin/duplicity)

[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/thibaultmorin/duplicity-cron?label=thibaultmorin%2Fduplicity-cron)](https://hub.docker.com/r/thibaultmorin/duplicity-cron)

[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/thibaultmorin/duplicity-mariadb?label=thibaultmorin%2Fduplicity-mariadb)](https://hub.docker.com/r/thibaultmorin/duplicity-mariadb)

[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/thibaultmorin/duplicity-postgres?label=thibaultmorin%2Fduplicity-postgres)](https://hub.docker.com/r/thibaultmorin/duplicity-postgres)

[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/thibaultmorin/duplicity-docker?label=thibaultmorin%2Fduplicity-docker)](https://hub.docker.com/r/thibaultmorin/duplicity-docker)

The projects build several images providing services based on [Duplicity](http://duplicity.nongnu.org/).

## `thibaultmorin/duplicity`

Docker Hub: [thibaultmorin/duplicity](https://hub.docker.com/r/thibaultmorin/duplicity)

This image bundles the Duplicity utility with most of the expected dependencies.

## `thibaultmorin/duplicity-cron`

Docker Hub: [thibaultmorin/duplicity](https://hub.docker.com/r/thibaultmorin/duplicity-cron)

The image is based on `thibaultmorin/duplicity` and provides a CRON environment.

The cron tasks can be defined by environment variables.

A task is identified by a `taskId` and is composed the following steps:

**1. prepare**: should be used to install stuff or to create directories ...<br>
**2. extract**: should be used to extract the data to backup<br>
**3. transform**: should be used to transform the extracted data<br>
**4. load**: should be used to call duplicity<br>
**5.1 succeed**: called when all previous steps ended successfully<br>
**5.2 failed**: called when one of the previous steps failed<br>
**6. finally**: always called, it should be used to release resources, cleaning ...

The task can be scheduled using the cron schedule expressions or using the built-in periodicity (hourly, ...).
The cron schedule expression is set with the environment variable `TASK_<taskId>_CRONTAB`.
The built-in periodicity (`hourly`, `daily`, `weekly`, `monthly`) is set with the environment variable `TASK_<taskId>_PERIODICITY`.

A restore task is marked with the environment variable `TASK_<taskId>_RESTORE`.
The value is the prefix of the task's file name.
So that, the execution of restore tasks can be ordered.
The command `execute-restore` executes the restore tasks.

The available environment variables:

`TASK_<taskId>_CRONTAB`
`TASK_<taskId>_PERIODICITY`
`TASK_<taskId>_RESTORE`
`TASK_<taskId>_PREPARE`
`TASK_<taskId>_EXTRACT`
`TASK_<taskId>_TRANSFORM`
`TASK_<taskId>_LOAD`
`TASK_<taskId>_SUCCEED`
`TASK_<taskId>_FAILED`
`TASK_<taskId>_FINALLY`

## `thibaultmorin/duplicity-docker`

Docker Hub: [thibaultmorin/duplicity-docker](https://hub.docker.com/r/thibaultmorin/duplicity-docker)

The image is based on `thibaultmorin/duplicity-cron` and provides a Docker environment.

## `thibaultmorin/duplicity-mariadb`

Docker Hub: [thibaultmorin/duplicity-mariadb](https://hub.docker.com/r/thibaultmorin/duplicity-mariadb)

The image is based on `thibaultmorin/duplicity-cron` and provides a MariaDB client.
Therefore, the image can be used to backup regularly dumps of MariaDB databases

## `thibaultmorin/duplicity-postgres`

Docker Hub: [thibaultmorin/duplicity-postgres](https://hub.docker.com/r/thibaultmorin/duplicity-postgres)

The image is based on `thibaultmorin/duplicity-cron` and provides a PostgreSQL client. Therefore, the image can be used to backup regularly dumps of PostgreSQL databases
