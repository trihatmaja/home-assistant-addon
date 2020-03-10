ARG BUILD_FROM=hassioaddons/base-amd64:7.0.3
ARG ARCH=amd64
ARG VERSION=2.16.0

ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION=${VERSION}

FROM ${BUILD_FROM}

RUN apk --no-cache add --virtual build-dependencies wget coreutils=8.31-r0 \
    && apk --no-cache add ca-certificates \
    && mkdir -p /tmp/install /tmp/dist \
    && wget -O /tmp/install/prometheus.tar.gz https://github.com/prometheus/prometheus/releases/download/v${VERSION}/prometheus-${VERSION}.linux-${ARCH}.tar.gz \
    && apk del build-dependencies \
    && cd /tmp/install \
    && tar --strip-components=1 -xzf prometheus.tar.gz \
    && mkdir -p /etc/prometheus /usr/share/prometheus \
    && mv prometheus promtool   /bin/ \
    && rm prometheus.yml \
    && mv consoles console_libraries NOTICE LICENSE /usr/share/prometheus/ \
    && ln -s /usr/share/prometheus/console_libraries /usr/share/prometheus/consoles/ /etc/prometheus/ \
    && rm -rf /tmp/install

# Labels
LABEL \
    io.hass.name="Prometheus" \
    io.hass.description="Prometheus add-on for hass.io" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Wicaksono Trihatmaja <trihatmaja@gmail.com>" \
    org.label-schema.description="Prometheus add-on for hass.io" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Prometheus" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://addons.community" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-example/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-example" \
    org.label-schema.vendor="Community Hass.io Addons"