ARG ROCKY_VERSION=10
FROM rockylinux/rockylinux:${ROCKY_VERSION}-minimal AS bare

HEALTHCHECK NONE

ARG RUBY_VERSION

ARG POSTGRES_VERSION=18

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

RUN if [ "${RUBY_VERSION}" = 3.3 ]; then ruby_pkg=ruby; else ruby_pkg="ruby${RUBY_VERSION}"; fi && \
    curl -o /etc/pki/rpm-gpg/PGDG-RPM-GPG-KEY-RHEL https://download.postgresql.org/pub/repos/yum/keys/PGDG-RPM-GPG-KEY-RHEL && \
    curl -o /etc/pki/rpm-gpg/PGDG-RPM-GPG-KEY-AARCH64-RHEL https://download.postgresql.org/pub/repos/yum/keys/PGDG-RPM-GPG-KEY-AARCH64-RHEL && \
    microdnf --nodocs -y install epel-release && \
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
    libyaml \
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
    "${ruby_pkg}" \
    "${ruby_pkg}-devel" \
    shared-mime-info \
    sqlite-devel \
    vim-minimal \
    zlib \
    zlib-devel \
    xz && \
    microdnf --nodocs reinstall -y tzdata && \
    microdnf clean all

ENV PATH=/usr/pgsql-${POSTGRES_VERSION}/bin:$PATH

RUN for f in /usr/bin/*"${RUBY_VERSION}"; do [ -e "$f" ] && ln -s "$f" "${f%"${RUBY_VERSION}"}"; done; \
    ruby -e 'abort "expected ruby #{ARGV[0]}, got #{RUBY_VERSION}" unless RUBY_VERSION.start_with?("#{ARGV[0]}.")' "${RUBY_VERSION}" && \
    gem install -N bundler

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
