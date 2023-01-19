ARG ROCKY_VERSION
FROM rockylinux:${ROCKY_VERSION}-minimal as bare

ARG RUBY_VERSION

ARG POSTGRES_VERSION

RUN microdnf --nodocs -y upgrade && \
    microdnf --nodocs -y install epel-release wget && \
    wget -q https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm -O /tmp/pg.rpm && \
    rpm -i /tmp/pg.rpm && \
    microdnf module disable -y postgresql && \
    microdnf module enable -y ruby:${RUBY_VERSION} && \
    microdnf --nodocs install -y \
    autoconf \
    automake \
    bash \
    bison \
    bzip2 \
    curl-devel \
    cronie \
    gcc-c++ \
    git-core \
    libffi-devel \
    libpq-devel \
    libtool \
    libyaml \
    libxml2-devel \
    libxslt-devel \
    make \
    openssl-devel \
    patch \
    postgresql${POSTGRES_VERSION} \
    procps-ng \
    redhat-rpm-config \
    ruby \
    ruby-irb \
    ruby-devel \
    readline-devel \
    shared-mime-info \
    sqlite-devel \
    vim \
    zlib \
    zlib-devel && \
    microdnf --nodocs reinstall -y tzdata && \
    microdnf clean all

RUN gem install bundler


FROM bare as default

ONBUILD ARG UID=1000
ONBUILD RUN useradd -d /ruby -l -m -Uu ${UID} -s /bin/bash ruby && \
    chown -R ${UID}:${UID} /ruby


FROM bare as jemalloc

ONBUILD ARG UID=1000
ONBUILD RUN useradd -d /ruby -l -m -Uu ${UID} -s /bin/bash ruby && \
    chown -R ${UID}:${UID} /ruby

RUN microdnf --nodocs install -y jemalloc

ENV LD_PRELOAD=/usr/lib64/libjemalloc.so.2


FROM bare as nodejs

RUN microdnf --nodocs install -y nodejs

ONBUILD ARG UID=1000
ONBUILD RUN useradd -d /ruby -l -m -Uu ${UID} -s /bin/bash ruby && \
    chown -R ${UID}:${UID} /ruby


FROM bare as nodejs-jemalloc

RUN microdnf --nodocs install -y \
    nodejs \
    jemalloc

ENV LD_PRELOAD=/usr/lib64/libjemalloc.so.2

ONBUILD ARG UID=1000
ONBUILD RUN useradd -d /ruby -l -m -Uu ${UID} -s /bin/bash ruby && \
    chown -R ${UID}:${UID} /ruby
