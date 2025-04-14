FROM debian:bookworm-slim

ARG DEBIAN_FRONTEND=noninteractive

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        git \
        jq \
        locales \
        sudo && \
    rm -rf /var/lib/apt/lists/*

RUN locale-gen en_NZ.UTF-8

ENV LANG=en_NZ.UTF-8 
ENV LANGUAGE=en_NZ.UTF-8

RUN useradd coder \
    --create-home \
    --shell /bin/bash \
    --uid 1000 \
    --user-group && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

USER coder