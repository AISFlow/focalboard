# syntax=docker/dockerfile:1

# -✂- this stage is Node.js build stage -------------------------------------------------
FROM node:lts AS nodebuild

WORKDIR /focalboard

ADD https://github.com/aisflow/focalboard-ko.git /focalboard/

WORKDIR /focalboard/webapp/
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/root/.npm,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        libtool automake autoconf pkg-config nasm build-essential zstd && \
    dpkgArch="$(dpkg --print-architecture)" && \
    case "${dpkgArch##*-}" in \
        amd64) \
            npm install --no-optional ;; \
        arm64) \
            CPPFLAGS="-DPNG_ARM_NEON_OPT=0" npm install --no-optional ;; \
        armhf) \
            CPPFLAGS="-DPNG_ARM_NEON_OPT=0" npm install --no-optional ;; \
        *) \
            echo "Unsupported architecture"; exit 1 ;; \
    esac && \
    npm run pack

# -✂- this stage is Golang build stage -------------------------------------------------
FROM golang:bookworm AS gobuild

ARG TARGETOS
ARG TARGETARCH

WORKDIR /go/src/focalboard
ADD https://github.com/aisflow/focalboard-ko.git /go/src/focalboard/

RUN --mount=type=cache,target=/go/pkg/mod,sharing=locked \
    EXCLUDE_PLUGIN=true \
    EXCLUDE_SERVER=true \
    EXCLUDE_ENTERPRISE=true \
    make server-docker os=${TARGETOS} arch=${TARGETARCH}

# -✂- this stage is final stage -------------------------------------------------
FROM debian:bookworm-slim AS final

ENV GOSU_VERSION=1.17
ENV TINI_VERSION=v0.19.0
ENV PATH="/opt/focalboard/bin:$PATH"
ENV UID=1001
ENV GID=1001
ENV TZ=Asia/Seoul

RUN set -eux; \
    groupadd --gid ${UID} focalboard; \
    useradd --uid ${UID} --gid ${GID} --home-dir /opt/focalboard focalboard; \
    install -d -o focalboard -g focalboard -m 700 /opt/focalboard

RUN set -eux; \
    # Save list of currently installed packages for later cleanup
        savedAptMark="$(apt-mark showmanual)"; \
        apt-get update; \
        apt-get install -y --no-install-recommends ca-certificates gnupg wget; \
        rm -rf /var/lib/apt/lists/*; \
        \
    # Install gosu
        dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
        wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
        wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
        export GNUPGHOME="$(mktemp -d)"; \
        gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
        gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
        gpgconf --kill all; \
        rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
        chmod +x /usr/local/bin/gosu; \
        gosu --version; \
        gosu nobody true; \
        \
    # Install Tini
        : "${TINI_VERSION:?TINI_VERSION is not set}"; \
        dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
        echo "Downloading Tini version ${TINI_VERSION} for architecture ${dpkgArch}"; \
        wget -O /usr/bin/tini "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-$dpkgArch"; \
        wget -O /usr/bin/tini.asc "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-$dpkgArch.asc"; \
        export GNUPGHOME="$(mktemp -d)"; \
        gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7; \
        gpg --batch --verify /usr/bin/tini.asc /usr/bin/tini; \
        gpgconf --kill all; \
        rm -rf "$GNUPGHOME" /usr/bin/tini.asc; \
        chmod +x /usr/bin/tini; \
        echo "Tini version: $(/usr/bin/tini --version)"; \
        \
    # Clean up
        apt-mark auto '.*' > /dev/null; \
        [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
        apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false

WORKDIR /opt/focalboard
COPY --link --from=nodebuild --chown=1001:1001 /focalboard/webapp/pack /opt/focalboard/pack/
COPY --link --from=gobuild --chown=1001:1001 /go/src/focalboard/bin/docker/focalboard-server /opt/focalboard/bin/
COPY --link --from=gobuild --chown=1001:1001 /go/src/focalboard/LICENSE.txt /opt/focalboard/LICENSE.txt
COPY --link --from=gobuild --chown=1001:1001 /go/src/focalboard/docker/server_config.json config.json

COPY scripts/start.sh /usr/bin/start

RUN mkdir -p /opt/focalboard/data/files && \
    chown -R focalboard:focalboard /opt/focalboard

VOLUME /opt/focalboard/data

ENTRYPOINT ["tini", "--", "start"]
CMD ["focalboard-server"]
