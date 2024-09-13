ARG ROCKY_VERSION
FROM rockylinux:${ROCKY_VERSION}-minimal AS bare

ARG RUBY_VERSION

ARG POSTGRES_VERSION

ARG ROCKY_VERSION

COPY <<-EOF "/etc/yum.repos.d/pgdg${POSTGRES_VERSION}.repo"
[pgdg-common]
name=PostgreSQL common RPMs for RHEL / Rocky / AlmaLinux \$releasever - \$basearch
baseurl=https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-\$releasever-\$basearch
enabled=1
gpgcheck=1

[pgdg-${POSTGRES_VERSION}]
name=PostgreSQL for RHEL / Rocky / AlmaLinux \$releasever - \$basearch
baseurl=https://download.postgresql.org/pub/repos/yum/${POSTGRES_VERSION}/redhat/rhel-\$releasever-\$basearch
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/PGDG-RPM-GPG-KEY-RHEL
EOF

RUN curl -o /etc/pki/rpm-gpg/PGDG-RPM-GPG-KEY-RHEL https://download.postgresql.org/pub/repos/yum/keys/PGDG-RPM-GPG-KEY-RHEL && \
    microdnf --nodocs -y install epel-release && \
    microdnf module enable -y "ruby:${RUBY_VERSION}" && \
    microdnf -y module disable postgresql && \
    microdnf --nodocs -y upgrade && \
    microdnf --enablerepo=crb --nodocs install -y \
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
    libtool \
    libxml2-devel \
    libxslt-devel \
    libyaml \
    make \
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
    vim \
    zlib \
    zlib-devel && \
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

RUN microdnf --nodocs install -y jemalloc

ENV LD_PRELOAD=/usr/lib64/libjemalloc.so.2


FROM bare AS nodejs

RUN microdnf --nodocs install -y nodejs

ONBUILD ARG UID=1000
ONBUILD RUN useradd -d /ruby -l -m -Uu ${UID} -s /bin/bash ruby && \
    chown -R ${UID}:${UID} /ruby


FROM bare AS nodejs-jemalloc

RUN microdnf --nodocs install -y \
    nodejs \
    jemalloc

ENV LD_PRELOAD=/usr/lib64/libjemalloc.so.2

ONBUILD ARG UID=1000
ONBUILD RUN useradd -d /ruby -l -m -Uu ${UID} -s /bin/bash ruby && \
    chown -R ${UID}:${UID} /ruby
