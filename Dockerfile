FROM registry.fedoraproject.org/fedora-minimal:34

ARG RUBY_VERSION
RUN microdnf --nodocs upgrade -y && \
  microdnf install -y fedora-repos-modular-34-2.noarch && \
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
  redhat-rpm-config \
  ruby \
  ruby-devel \
  readline-devel \
  shared-mime-info \
  sqlite-devel \
  zlib \
  zlib-devel && \
  microdnf --nodocs reinstall -y tzdata && \
  microdnf clean all

ONBUILD ARG UID=1000
ONBUILD RUN useradd -d /ruby -l -m -Uu ${UID} -r -s /bin/bash ruby && \
  chown -R ${UID}:${UID} /ruby

RUN gem install bundler
