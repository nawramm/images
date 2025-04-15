FROM ghcr.io/nawramm/images/base:latest

USER root

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-ply \
        python3-pip \
        default-jre && \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    echo "Verifying installation"; \
    echo "python3 --version"; python3 --version; \
    echo "python3 -c \"import ply.lex\""; python3 -c "import ply.lex"; \
    echo "java --version"; java --version;

USER coder