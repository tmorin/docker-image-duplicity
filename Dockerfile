FROM ubuntu:eoan as no-backend
ARG version="0.8.17"
ARG git_sha=""
LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.vendor="tmorin" \
      org.label-schema.license="MIT" \
      org.label-schema.vcs-ref="$git_sha" \
      org.label-schema.vcs-url="https://github.com/tmorin/docker-image-duplicity"
ENV PASSPHRASE="passphrase"
RUN apt-get update -y \
    && apt-get install -y \
        # install dependencies
        rsync \
        lftp \
        ncftp \
        par2 \
        tahoe-lafs \
        python3-pip \
        # install libraries
        gettext \
        librsync2 \
        libffi6 \
        libxslt1.1 \
        # install dev libraries
        librsync-dev \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
    && pip3 install \
        # install basic libraries
        fasteners \
        future \
        mock \
        python-gettext \
        requests \
        setuptools \
        setuptools_scm \
        urllib3 \
        # install duplicity
        https://launchpad.net/duplicity/$(echo ${version} | sed -r 's/^([0-9]+\.[0-9]+)([0-9\.]*)$/\1/')-series/${version}/+download/duplicity-${version}.tar.gz \
    # cleanning
    && apt-get clean \
    && apt-get remove -y \
        librsync-dev \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
    && apt-get autoremove -y \
    && rm -rf /var/cache/apt/* /var/lib/apt/lists/* ~/.cache
WORKDIR /workdir
ENTRYPOINT [ "duplicity" ]

FROM no-backend as duplicity
ARG git_sha=""
LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.vendor="tmorin" \
      org.label-schema.license="MIT" \
      org.label-schema.vcs-ref="$git_sha" \
      org.label-schema.vcs-url="https://github.com/tmorin/docker-image-duplicity"
RUN apt-get update -y \
    && apt-get install -y \
        # install dev libraries
        librsync-dev \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
    # install backend libraries
    && pip3 install azure-mgmt-storage \
    && pip3 install b2sdk \
    && pip3 install boto \
    && pip3 install boto3 \
    && pip3 install dropbox \
    && pip3 install gdata \
    && pip3 install jottalib \
    && pip3 install mediafire \
    && pip3 install pydrive \
    && pip3 install pyrax \
    && pip3 install python-swiftclient \
    && pip3 install requests_oauthlib \
    # cleanning
    && apt-get clean \
    && apt-get remove -y \
        librsync-dev \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
    && apt-get autoremove -y \
    && rm -rf /var/cache/apt/* /var/lib/apt/lists/* ~/.cache

FROM duplicity as cron
ARG git_sha=""
LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.vendor="tmorin" \
      org.label-schema.license="MIT" \
      org.label-schema.vcs-ref="$git_sha" \
      org.label-schema.vcs-url="https://github.com/tmorin/docker-image-duplicity"
RUN apt-get update -y \
    # install cron
    && apt-get install -y cron \
    # cleanning
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/cache/apt/* /var/lib/apt/lists/* /etc/cron.daily/* /etc/cron.hourly/* /etc/cron.monthly/* /etc/cron.weekly/* \
    # install setup-cron
    && ln -s /usr/local/lib/setup-cron.py /usr/local/bin/setup-cron
COPY rootfs /
CMD cron -fl
ENTRYPOINT [ "/entrypoint.sh" ]


FROM cron as mariadb
ARG git_sha=""
LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.vendor="tmorin" \
      org.label-schema.license="MIT" \
      org.label-schema.vcs-ref="$git_sha" \
      org.label-schema.vcs-url="https://github.com/tmorin/docker-image-duplicity"
RUN apt-get update -y \
    && apt-get install -y mariadb-client \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/cache/apt/* /var/lib/apt/lists/*


FROM cron as postgres
ARG git_sha=""
LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.vendor="tmorin" \
      org.label-schema.license="MIT" \
      org.label-schema.vcs-ref="$git_sha" \
      org.label-schema.vcs-url="https://github.com/tmorin/docker-image-duplicity"
RUN apt-get update -y \
    && apt-get install -y postgresql-client \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/cache/apt/* /var/lib/apt/lists/*


FROM cron as docker
ARG git_sha=""
LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.vendor="tmorin" \
      org.label-schema.license="MIT" \
      org.label-schema.vcs-ref="$git_sha" \
      org.label-schema.vcs-url="https://github.com/tmorin/docker-image-duplicity"
RUN apt-get update -y \
    && apt-get install -y docker.io \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/cache/apt/* /var/lib/apt/lists/*
