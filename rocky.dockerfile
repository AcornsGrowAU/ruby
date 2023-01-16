ARG ROCKY_VERSION
FROM rockylinux:${ROCKY_VERSION}-minimal as bare

ARG RUBY_VERSION

RUN microdnf --nodocs -y upgrade && \
    microdnf module enable -y ruby:${RUBY_VERSION} && \
    microdnf --nodocs install -y epel-release && \
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
    nodejs \
    openssl-devel \
    patch \
    postgresql \
    procps-ng \
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


FROM bare as base

ONBUILD ARG UID=1000
ONBUILD RUN useradd -d /ruby -l -m -Uu ${UID} -r -s /bin/bash ruby && \
    chown -R ${UID}:${UID} /ruby


FROM bare as jemalloc

ONBUILD ARG UID=1000
ONBUILD RUN useradd -d /ruby -l -m -Uu ${UID} -r -s /bin/bash ruby && \
    chown -R ${UID}:${UID} /ruby

RUN microdnf --nodocs install -y jemalloc

ENV LD_PRELOAD=/usr/lib64/libjemalloc.so.2
