ARG ROCKY_VERSION
FROM rockylinux:${ROCKY_VERSION}-minimal as bare

ARG RUBY_VERSION

ARG POSTGRES_VERSION

ARG ROCKY_VERSION

RUN microdnf --nodocs -y upgrade && \
    microdnf --nodocs -y install epel-release && \
    microdnf module enable -y "ruby:${RUBY_VERSION}" && \
    rpm -i "https://download.postgresql.org/pub/repos/yum/reporpms/EL-${ROCKY_VERSION}-$(arch)/pgdg-redhat-repo-latest.noarch.rpm" && \
    microdnf -y module disable postgresql && \
    microdnf --nodocs install -y \
    autoconf \
    automake \
    bash \
    bison \
    bzip2 \
    cronie \
    curl-devel \
    gcc-c++ \
    git-core \
    libffi-devel \
    libpq-devel \
    libtool \
    libxml2-devel \
    libxslt-devel \
    libyaml \
    make \
    openssl-devel \
    patch \
    "postgresql${POSTGRES_VERSION}" \
    procps-ng \
    readline-devel \
    redhat-rpm-config \
    ruby \
    ruby-devel \
    ruby-irb \
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
