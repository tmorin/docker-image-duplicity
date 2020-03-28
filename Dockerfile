FROM alpine AS base
ARG version=0.8.08
ARG prefix=-r0
ARG vcs_ref
ARG build_date
LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.vendor=tmorin \
      org.label-schema.license=Apache-2.0 \
      org.label-schema.build-date="$build_date" \
      org.label-schema.vcs-ref="$vcs_ref" \
      org.label-schema.vcs-url="https://github.com/tmorin/docker-image-duplicity"
ENV CRONTAB_15MIN='*/15 * * * *' \
    CRONTAB_HOURLY='0 * * * *' \
    CRONTAB_DAILY='0 2 * * MON-SAT' \
    CRONTAB_WEEKLY='0 1 * * SUN' \
    CRONTAB_MONTHLY='0 5 1 * *' \
    DST='' \
    EMAIL_FROM='' \
    EMAIL_SUBJECT='Backup report: {hostname} - {periodicity} - {result}' \
    EMAIL_TO='' \
    JOB_300_WHAT='backup' \
    JOB_300_WHEN='daily' \
    OPTIONS='' \
    OPTIONS_EXTRA='--metadata-sync-mode partial' \
    SMTP_HOST='smtp' \
    SMTP_PASS='' \
    SMTP_PORT='25' \
    SMTP_TLS='' \
    SMTP_USER='' \
    SRC='/mnt/backup/src'
# Link the job runner in all periodicities available
RUN ln -s /usr/local/bin/jobrunner /etc/periodic/15min/jobrunner \
    && ln -s /usr/local/bin/jobrunner /etc/periodic/hourly/jobrunner \
    && ln -s /usr/local/bin/jobrunner /etc/periodic/daily/jobrunner \
    && ln -s /usr/local/bin/jobrunner /etc/periodic/weekly/jobrunner \
    && ln -s /usr/local/bin/jobrunner /etc/periodic/monthly/jobrunner \
    # Runtime dependencies and database clients
    && apk add --no-cache duplicity=${version}${prefix} \
    # Default backup source directory
    && mkdir -p "$SRC"
# Preserve cache among containers
VOLUME [ "/root" ]
ENTRYPOINT [ "/usr/local/bin/entrypoint" ]
CMD ["/usr/sbin/crond", "-fd8"]


FROM base AS docker
RUN apk add --no-cache docker


FROM base AS postgres
RUN apk add --no-cache postgresql-client
ENV JOB_200_WHAT psql -0Atd postgres -c \"SELECT datname FROM pg_database WHERE NOT datistemplate AND datname != \'postgres\'\" | xargs -0tI DB pg_dump --dbname DB --no-owner --no-privileges --file \"\$SRC/DB.sql\"
ENV JOB_200_WHEN='daily weekly' \
    PGHOST=db


FROM base AS mariadb
RUN apk add --no-cache mariadb-client
ENV JOB_200_WHAT mysqldump --host=$MYSQL_HOST --user=$MYSQL_USER --password=$MYSQL_PASSWORD $MYSQL_DATABASE > \"\$SRC/$MYSQL_DATABASE.sql\"
ENV JOB_200_WHEN='daily weekly' \
    MYSQL_HOST="db" \
    MYSQL_USER="user" \
    MYSQL_PASSWORD="password" \
    MYSQL_DATABASE="database"
