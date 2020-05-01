# docker-image-duplicity

[![Build Status](https://travis-ci.org/tmorin/docker-image-duplicity.svg)](https://travis-ci.org/tmorin/docker-image-duplicity)

The projects build several images providing services based on [Duplicity](http://duplicity.nongnu.org/).

## `thibaultmorin/duplicity`

[![](https://images.microbadger.com/badges/version/thibaultmorin/duplicity:latest.svg)](https://microbadger.com/images/thibaultmorin/duplicity)
[![](https://images.microbadger.com/badges/image/thibaultmorin/duplicity:latest.svg)](https://microbadger.com/images/thibaultmorin/duplicity)
[![](https://images.microbadger.com/badges/commit/thibaultmorin/duplicity:latest.svg)](https://microbadger.com/images/thibaultmorin/duplicity)
[![](https://images.microbadger.com/badges/license/thibaultmorin/duplicity.svg)](https://microbadger.com/images/thibaultmorin/duplicity)

This image bundles the Duplicity utility with most of the expected dependencies. Only `python-cloudfiles` cannot be installed, therefore the backend CloudFiles is not available.

## `thibaultmorin/cron`

[![](https://images.microbadger.com/badges/version/thibaultmorin/duplicity-cron:latest.svg)](https://microbadger.com/images/thibaultmorin/duplicity-cron)
[![](https://images.microbadger.com/badges/image/thibaultmorin/duplicity-cron:latest.svg)](https://microbadger.com/images/thibaultmorin/duplicity-cron)
[![](https://images.microbadger.com/badges/commit/thibaultmorin/duplicity-cron:latest.svg)](https://microbadger.com/images/thibaultmorin/duplicity-cron)
[![](https://images.microbadger.com/badges/license/thibaultmorin/duplicity-cron.svg)](https://microbadger.com/images/thibaultmorin/duplicity-cron)

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
The built-in periodicity is set with the environment variable `TASK_<taskId>_CRONTAB`.

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

## `thibaultmorin/docker`

[![](https://images.microbadger.com/badges/version/thibaultmorin/duplicity-docker:latest.svg)](https://microbadger.com/images/thibaultmorin/duplicity-docker)
[![](https://images.microbadger.com/badges/image/thibaultmorin/duplicity-docker:latest.svg)](https://microbadger.com/images/thibaultmorin/duplicity-docker)
[![](https://images.microbadger.com/badges/commit/thibaultmorin/duplicity-docker:latest.svg)](https://microbadger.com/images/thibaultmorin/duplicity-docker)
[![](https://images.microbadger.com/badges/license/thibaultmorin/duplicity-docker.svg)](https://microbadger.com/images/thibaultmorin/duplicity-docker)

The image is based on `thibaultmorin/cron` and provides a Docker environment.

## `thibaultmorin/mariadb`

[![](https://images.microbadger.com/badges/version/thibaultmorin/duplicity-mariadb:latest.svg)](https://microbadger.com/images/thibaultmorin/duplicity-mariadb)
[![](https://images.microbadger.com/badges/image/thibaultmorin/duplicity-mariadb:latest.svg)](https://microbadger.com/images/thibaultmorin/duplicity-mariadb)
[![](https://images.microbadger.com/badges/commit/thibaultmorin/duplicity-mariadb:latest.svg)](https://microbadger.com/images/thibaultmorin/duplicity-mariadb)
[![](https://images.microbadger.com/badges/license/thibaultmorin/duplicity-mariadb.svg)](https://microbadger.com/images/thibaultmorin/duplicity-mariadb)

The image is based on `thibaultmorin/cron` and provides a MariaDB client. Therefore the image can be used to backup regularly dumps of MariaDB databases

## `thibaultmorin/postgre`

[![](https://images.microbadger.com/badges/version/thibaultmorin/duplicity-postgre:latest.svg)](https://microbadger.com/images/thibaultmorin/duplicity-postgre)
[![](https://images.microbadger.com/badges/image/thibaultmorin/duplicity-postgre:latest.svg)](https://microbadger.com/images/thibaultmorin/duplicity-postgre)
[![](https://images.microbadger.com/badges/commit/thibaultmorin/duplicity-postgre:latest.svg)](https://microbadger.com/images/thibaultmorin/duplicity-postgre)
[![](https://images.microbadger.com/badges/license/thibaultmorin/duplicity-postgre.svg)](https://microbadger.com/images/thibaultmorin/duplicity-postgre)

The image is based on `thibaultmorin/cron` and provides a PostgreSQL client. Therefore the image can be used to backup regularly dumps of PostgreSQL databases
