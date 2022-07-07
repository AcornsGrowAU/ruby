ARG FEDORA_VERSION
FROM registry.fedoraproject.org/fedora-minimal:${FEDORA_VERSION} as bare

ARG RUBY_VERSION

RUN microdnf --nodocs -y upgrade && \
    microdnf --nodocs -y install fedora-repos-modular && \
    microdnf module enable -y ruby:${RUBY_VERSION} && \
    microdnf module enable -y nodejs:14 && \
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
    libyaml-devel \
    libxml2-devel \
    libxslt-devel \
    make \
    nodejs \
    openssl-devel \
    patch \
    postgresql \
    procps-ng \
    redhat-rpm-config \
    ruby \
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
