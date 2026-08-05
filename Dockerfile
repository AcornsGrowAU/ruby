ARG ROCKY_VERSION=9
FROM rockylinux:${ROCKY_VERSION}-minimal AS bare

HEALTHCHECK NONE

ARG RUBY_VERSION=3.3

ARG POSTGRES_VERSION=17

ARG ROCKY_VERSION

# PGDG repos aren't modular and a pain to use "lightly", so we just deploy the ones we need
COPY <<-EOF "/etc/yum.repos.d/pgdg${POSTGRES_VERSION}.repo"
[pgdg-common]
name=PostgreSQL common RPMs
baseurl=https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-\$releasever-\$basearch
enabled=1
gpgcheck=1

[pgdg-${POSTGRES_VERSION}]
name=PostgreSQL RPMs
baseurl=https://download.postgresql.org/pub/repos/yum/${POSTGRES_VERSION}/redhat/rhel-\$releasever-\$basearch
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/PGDG-RPM-GPG-KEY-RHEL
EOF

RUN curl -o /etc/pki/rpm-gpg/PGDG-RPM-GPG-KEY-RHEL https://download.postgresql.org/pub/repos/yum/keys/PGDG-RPM-GPG-KEY-RHEL && \
    curl -o /etc/pki/rpm-gpg/PGDG-RPM-GPG-KEY-AARCH64-RHEL https://download.postgresql.org/pub/repos/yum/keys/PGDG-RPM-GPG-KEY-AARCH64-RHEL && \
    microdnf --nodocs -y install epel-release && \
    microdnf -y module disable postgresql && \
    microdnf module enable -y "ruby:${RUBY_VERSION}" && \
    microdnf --nodocs -y upgrade && \
    microdnf --enablerepo=crb --nodocs install -y \
    autoconf \
    automake \
    bash \
    bison \
    bzip2 \
    ca-certificates \
    fontconfig \
    gcc-c++ \
    git-core \
    libcurl-devel \
    libffi-devel \
    libsass-devel \
    libtool \
    libxml2-devel \
    libxslt-devel \
    libXext-devel \
    libXrender-devel \
    libyaml\
    libyaml-devel \
    make \
    netcat \
    openssl-devel \
    patch \
    "postgresql${POSTGRES_VERSION}" \
    "postgresql${POSTGRES_VERSION}-devel" \
    procps-ng \
    readline-devel \
    redhat-rpm-config \
    ruby \
    ruby-devel \
    ruby-irb \
    shared-mime-info \
    sqlite-devel \
    vim-minimal \
    wget \
    zlib \
    zlib-devel \
    xz && \
    microdnf --nodocs reinstall -y tzdata && \
    microdnf clean all

ENV PATH=/usr/pgsql-${POSTGRES_VERSION}/bin:$PATH

RUN gem install -N bundler


FROM bare AS default

ONBUILD ARG UID=1000
ONBUILD RUN useradd -d /ruby -l -m -Uu ${UID} -s /bin/bash ruby && \
    chown -R ${UID}:${UID} /ruby


FROM bare AS jemalloc

ONBUILD ARG UID=1000
ONBUILD RUN useradd -d /ruby -l -m -Uu ${UID} -s /bin/bash ruby && \
    chown -R ${UID}:${UID} /ruby

RUN microdnf --nodocs install -y jemalloc && \
    microdnf clean all

ENV LD_PRELOAD=/usr/lib64/libjemalloc.so.2


FROM bare AS nodejs

RUN microdnf --nodocs install -y nodejs && \
    microdnf clean all


ONBUILD ARG UID=1000
ONBUILD RUN useradd -d /ruby -l -m -Uu ${UID} -s /bin/bash ruby && \
    chown -R ${UID}:${UID} /ruby


FROM bare AS nodejs-jemalloc

RUN microdnf --nodocs install -y \
    nodejs \
    jemalloc && \
    microdnf clean all

ENV LD_PRELOAD=/usr/lib64/libjemalloc.so.2

ONBUILD ARG UID=1000
ONBUILD RUN useradd -d /ruby -l -m -Uu ${UID} -s /bin/bash ruby && \
    chown -R ${UID}:${UID} /ruby
