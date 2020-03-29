FROM ubuntu:eoan as no-backend-libraries
ARG version=0.8.12
ARG prefix=.1612
ARG vcs_ref
ARG build_date
LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.vendor="tmorin" \
      org.label-schema.license="MIT" \
      org.label-schema.build-date="$build_date" \
      org.label-schema.vcs-ref="$vcs_ref" \
      org.label-schema.vcs-url="https://github.com/tmorin/docker-image-duplicity"
ENV PASSPHRASE=""
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
        urllib3 \
        # install duplicity
        https://launchpad.net/duplicity/$(echo ${version} | sed -r 's/^([0-9]+\.[0-9]+)([0-9\.]*)$/\1/')-series/${version}/+download/duplicity-${version}${prefix}.tar.gz \
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


FROM no-backend-libraries as duplicity
RUN apt-get update -y \
    && apt-get install -y \
        # install dev libraries
        librsync-dev \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
    # install backend libraries
    && pip3 install \
        requests_oauthlib \
    && pip3 install \
        azure \
    && pip3 install \
        b2sdk \
    && pip3 install \
        boto \
    && pip3 install \
        boto3 \
    && pip3 install \
        dropbox==6.9.0 \
    && pip3 install \
        gdata \
    && pip3 install \
        jottalib \
    && pip3 install \
        mediafire \
    && pip3 install \
        pydrive \
    && pip3 install \
        pyrax \
        # python-cloudfiles \
    && pip3 install \
        python-swiftclient \
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
RUN apt-get update -y \
    # install cron
    && apt-get install -y cron \
    # cleanning
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/cache/apt/* /var/lib/apt/lists/*\
    # install setup-cron
    && ln -s /usr/local/lib/setup-cron.py /usr/local/bin/setup-cron
COPY rootfs /
CMD cron -flL0
ENTRYPOINT [ "/entrypoint.sh" ]


FROM cron as mariadb
RUN apt-get update -y \
    && apt-get install -y mariadb-client \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/cache/apt/* /var/lib/apt/lists/*


FROM cron as postgres
RUN apt-get update -y \
    && apt-get install -y postgresql-client \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/cache/apt/* /var/lib/apt/lists/*


FROM cron as docker
RUN apt-get update -y \
    && apt-get install -y docker.io \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/cache/apt/* /var/lib/apt/lists/*
