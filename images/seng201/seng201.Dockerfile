FROM ghcr.io/nawramm/images/base:latest

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget &&\
    rm -rf /var/lib/apt/lists/*

ENV JAVA_VERSION=jdk-21.0.6+7
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

RUN set -eux; \
    ARCH=$(dpkg --print-architecture); \
    case "${ARCH}" in \
        amd64) \
            JAVA_URL='https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.6%2B7/OpenJDK21U-jdk_x64_linux_hotspot_21.0.6_7.tar.gz'; \
            ;; \
        arm64) \
            JAVA_URL='https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.6%2B7/OpenJDK21U-jdk_aarch64_linux_hotspot_21.0.6_7.tar.gz'; \
            ;; \
        *) \
            echo >&2 "error: unsupported architecture '${ARCH}'"; \
            exit 1; \
            ;; \
    esac; \
    wget -O /tmp/openjdk.tar.gz "${JAVA_URL}"; \
    mkdir -p "${JAVA_HOME}"; \
    tar -xzf /tmp/openjdk.tar.gz -C "${JAVA_HOME}" --strip-components=1; \
    rm -f /tmp/openjdk.tar.gz ${JAVA_HOME}/lib/src.zip; \
    find "${JAVA_HOME}" -type f -name '*.so' -exec dirname '{}' ';' | sort -u > /etc/ld.so.conf.d/docker-openjdk.conf; \
    ldconfig; \
    java -Xshare:dump;

RUN set -eux; \
    echo "Verifying Java installation"; \
    echo "javac --version"; javac --version; \
    echo "java --version"; java --version;

USER coder
